module FerretMixin
  module Acts #:nodoc:
    module ARFerret #:nodoc:
      
      # declare the class level helper methods
      # which will load the relevant instance methods defined below when invoked
      module ClassMethods
        
        # helper that defines a method that adds the given field to a lucene 
        # document instance
        def define_to_field_method(field, options = {})         
          options = { 
            :store => :no, 
            :highlight => :yes, 
            :index => :yes, 
            :term_vector => :with_positions_offsets,
            :boost => 1.0 }.update(options)
          fields_for_ferret[field] = options
          define_method("#{field}_to_ferret".to_sym) do
            begin
              val = content_for_field_name(field)
            rescue
              logger.warn("Error retrieving value for field #{field}: #{$!}")
              val = ''
            end
            logger.debug("Adding field #{field} with value '#{val}' to index")
            val
          end
        end

        def add_fields(field_config)
          if field_config.respond_to?(:each_pair)
            field_config.each_pair do |key,val|
              define_to_field_method(key,val)                  
            end
          elsif field_config.respond_to?(:each)
            field_config.each do |field| 
              define_to_field_method(field)
            end                
          end
        end
        
        def reloadable?; false end
        
        @@ferret_indexes = Hash.new
        def ferret_indexes; @@ferret_indexes end
        
        @@multi_indexes = Hash.new
        def multi_indexes; @@multi_indexes end
        
        # declares a class as ferret-searchable. 
        #
        # ====options:
        # fields:: names all fields to include in the index. If not given,
        #          all attributes of the class will be indexed. You may also give
        #          symbols pointing to instance methods of your model here, i.e. 
        #          to retrieve and index data from a related model. 
        #
        # additional_fields:: names fields to include in the index, in addition 
        #                     to those derived from the db scheme. use if you want 
        #                     to add custom fields derived from methods to the db 
        #                     fields (which will be picked by aaf). This option will 
        #                     be ignored when the fields option is given, in that 
        #                     case additional fields get specified there.
        #
        # index_dir:: declares the directory where to put the index for this class.
        #             The default is RAILS_ROOT/index/RAILS_ENV/CLASSNAME. 
        #             The index directory will be created if it doesn't exist.
        #
        # single_index:: set this to true to let this class use a Ferret
        #                index that is shared by all classes having :single_index set to true.
        #                :store_class_name is set to true implicitly, as well as index_dir, so 
        #                don't bother setting these when using this option. the shared index
        #                will be located in index/<RAILS_ENV>/shared .
        #
        # store_class_name:: to make search across multiple models useful, set
        #                    this to true. the model class name will be stored in a keyword field 
        #                    named class_name
        #
        # ====ferret_options:
        # or_default:: whether query terms are required by
        #              default (the default, false), or not (true)
        # 
        # analyzer:: the analyzer to use for query parsing (default: nil,
        #            which means the ferret StandardAnalyzer gets used)
        #
        def acts_as_ferret(options={}, ferret_options={})
          configuration = { 
            :index_dir => "#{FerretMixin::Acts::ARFerret::index_dir}/#{self.name.underscore}",
            :store_class_name => false,
            :single_index => false,
          }
          ferret_configuration = {
            :or_default => false, 
            :handle_parse_errors => true,
            :default_field => '*'
            #:max_clauses => 512,
            #:analyzer => Ferret::Analysis::StandardAnalyzer.new,
            # :wild_card_downcase => true
          }
          configuration.update(options) if options.is_a?(Hash)

          # apply appropriate settings for shared index
          if configuration[:single_index] 
            configuration[:index_dir] = "#{FerretMixin::Acts::ARFerret::index_dir}/shared" 
            configuration[:store_class_name] = true 
          end
          ferret_configuration.update(ferret_options) if ferret_options.is_a?(Hash)
          # these properties are somewhat vital to the plugin and shouldn't
          # be overwritten by the user:
          ferret_configuration.update(

            :key               => (configuration[:single_index] ? [:id, :class_name] : :id),
            :path              => configuration[:index_dir],
            :auto_flush        => true,
            :create_if_missing => true
          )
          
          class_eval <<-EOV
              include FerretMixin::Acts::ARFerret::InstanceMethods


              after_create :ferret_create
              after_update :ferret_update
              after_destroy :ferret_destroy      
              
              cattr_accessor :fields_for_ferret   
              cattr_accessor :configuration
              cattr_accessor :ferret_configuration
              
              @@fields_for_ferret = Hash.new
              @@configuration = configuration
              @@ferret_configuration = ferret_configuration

              if configuration[:fields]
                add_fields(configuration[:fields])
              else
                add_fields(self.new.attributes.keys.map { |k| k.to_sym })
                add_fields(configuration[:additional_fields])
              end

            EOV
          FerretMixin::Acts::ARFerret::ensure_directory configuration[:index_dir]

          # now that all fields have been added, we can initialize the default
          # field list to be used by the query parser.
          # It will include all content fields *not* marked as :untokenized.
          # This fixes the otherwise failing CommentTest#test_stopwords 
          ferret_configuration[:default_field] = fields_for_ferret.keys.select do |f| 
            fields_for_ferret[f][:index] != :untokenized
          end
          logger.debug "set default field list to #{ferret_configuration[:default_field].inspect}"
        end
        
        def class_index_dir
          configuration[:index_dir]
        end
        
        # rebuild the index from all data stored for this model.
        # This is called automatically when no index exists yet.
        #
        # TODO: the automatic index initialization only works if 
        # every model class has it's 
        # own index, otherwise the index will get populated only
        # with instances from the first model loaded
        #
        # When calling this method manually, you can give any additional 
        # model classes that should also go into this index as parameters. 
        # Useful when using the :single_index option.
        # Note that attributes named the same in different models will share
        # the same field options in the shared index.
        def rebuild_index(*models)
          models << self
          # default attributes for fields
          fi = Ferret::Index::FieldInfos.new(:store => :no, 
                                             :index => :yes, 
                                             :term_vector => :no,
                                             :boost => 1.0)
          # primary key
          fi.add_field(:id, :store => :yes, :index => :untokenized) 
          # class_name
          if configuration[:store_class_name]
            fi.add_field(:class_name, :store => :yes, :index => :untokenized) 
          end
          # collect field options from all models
          fields = {}
          models.each do |model|
            fields.update(model.fields_for_ferret)
          end
          logger.debug("class #{self.name}: fields for index: #{fields.keys.join(',')}")
          fields.each_pair do |field, options|
            fi.add_field(field, { :store => :no, 
                                  :index => :yes }.update(options)) 
          end
          fi.create_index(ferret_configuration[:path])

          index = Ferret::Index::Index.new(ferret_configuration.dup.update(:auto_flush => false))
          #index = Ferret::Index::Index.new(ferret_configuration.dup.update(:auto_flush => true))
          batch_size = 1000
          models.each do |model|
            # index in batches of 1000 to limit memory consumption (fixes #24)
            model.transaction do
              0.step(model.count, batch_size) do |i|
                model.find(:all, :limit => batch_size, :offset => i).each do |rec|
                  index << rec.to_doc
                end
              end
            end
          end
          logger.debug("Created Ferret index in: #{class_index_dir}")
          index.flush
          index.optimize
          index.close
          # close combined index readers, just in case
          # this seems to fix a strange test failure that seems to relate to a
          # multi_index looking at an old version of the content_base index.
          @@multi_indexes.each_pair do |key, index|
            # puts "#{key} -- #{self.name}"
            # TODO only close those where necessary (watch inheritance, where
            # self.name is base class of a class where key is made from)
            index.close #if key =~ /#{self.name}/
          end
          @@multi_indexes = Hash.new
        end                                                            
        
        # Retrieve the Ferret::Index::Index instance for this model class.
        # 
        # Index instances are stored in a hash, using the index directory
        # as the key. So model classes sharing a single index will share their
        # Index object, too.
        def ferret_index
          ferret_indexes[class_index_dir] ||= create_index_instance
        end 
        
        # creates a new Index::Index instance. Before that, a check is done
        # to see if the index exists in the file system. If not, index rebuild
        # from all model data retrieved by find(:all) is triggered.
        def create_index_instance
          rebuild_index unless File.file? "#{class_index_dir}/segments"
          Ferret::Index::Index.new(ferret_configuration)
        end
        
        # Finds instances by contents. Terms are ANDed by default, can be circumvented 
        # by using OR between terms. 
        # options:
        # offset::      first hit to retrieve (useful for paging)
        # limit::       number of hits to retrieve, or :all to retrieve
        #               all results
        # models::      only for single_index scenarios: a list of other Model classes to 
        #               include in this search.
        #
        # find_options is a hash passed on to active_record's find when
        # retrieving the data from db, useful to i.e. prefetch relationships.
        #
        # this method returns a SearchResults instance, which really is an Array that has 
        # been decorated with a total_hits accessor that delivers the total
        # number of hits (including those not fetched because of a low num_docs
        # value).
        # Please keep in mind that the number of total hits might be wrong if you specify 
        # both ferret options and active record find_options that somehow limit the result 
        # set (e.g. :num_docs and some :conditions).
        def find_by_contents(q, options = {}, find_options = {})
          # handle shared index
          return single_index_find_by_contents(q, options, find_options) if configuration[:single_index]
          results = {}
          total_hits = find_id_by_contents(q, options) do |model, id, score|
            # stores ids, index of each id for later ordering of
            # results, and score
            results[id] = [ results.size + 1, score ]
          end
          result = []
          begin
            # TODO: in case of STI AR will filter out hits from other 
            # classes for us, but this
            # will lead to less results retrieved --> scoping of ferret query
            # to self.class is still needed.
            # from the ferret ML (thanks Curtis Hatter)
            # > I created a method in my base STI class so I can scope my query. For scoping
            # > I used something like the following line:
            # > 
            # > query << " role:#{self.class.eql?(Contents) '*' : self.class}"
            # > 
            # > Though you could make it more generic by simply asking
            # > "self.descends_from_active_record?" which is how rails decides if it should
            # > scope your "find" query for STI models. You can check out "base.rb" in
            # > activerecord to see that.
            # but maybe better do the scoping in find_id_by_contents...
            if results.any?
              conditions = combine_conditions([ "#{table_name}.#{primary_key} in (?)", results.keys ], 
                                              find_options[:conditions])
              result = self.find(:all, 
                                 find_options.merge(:conditions => conditions))
              # correct result size if the user specified conditions
              total_hits = result.length if find_options[:conditions]
            end
          rescue ActiveRecord::RecordNotFound
            logger.warn "REBUILD YOUR INDEX! One of the id's in the index didn't have an associated record"
          end

          # order results as they were found by ferret, unless an AR :order
          # option was given
          unless find_options[:order]
            result.sort! { |a, b| results[a.id.to_s].first <=> results[b.id.to_s].first }
          end
          # set scores
          result.each { |r| r.ferret_score = results[r.id.to_s].last }
          
          logger.debug "Query: #{q}\nResult ids: #{results.keys.inspect},\nresult: #{result}"
          return SearchResults.new(result, total_hits)
        end 

        # determine all field names in the shared index
        def single_index_field_names(models)
          @single_index_field_names ||= (
              searcher = Ferret::Search::Searcher.new(class_index_dir)
              if searcher.reader.respond_to?(:get_field_names)
                (searcher.reader.send(:get_field_names) - ['id', 'class_name']).to_a
              else
                puts <<-END
  unable to retrieve field names for class #{self.name}, please 
  consider naming all indexed fields in your call to acts_as_ferret!
                END
                models.map { |m| m.content_columns.map { |col| col.name } }.flatten
              end
          )

        end
        

        # weiter: checken ob ferret-bug, dass wir die queries so selber bauen
        # muessen - liegt am downcasen des qparsers ? - gucken ob jetzt mit
        # ferret geht (content_cols) und dave um zugriff auf qp bitten, oder
        # auf reader
        # TODO: slow on large result sets - fetches result set objects one-by-one
        def single_index_find_by_contents(q, options = {}, find_options = {})
          result = []

          unless options[:models] == :all # search needs to be restricted by one or more class names
            options[:models] ||= [] 
            # add this class to the list of given models
            options[:models] << self unless options[:models].include?(self)
            # keep original query 
            original_query = q
            
            # work around ferret bug in #process_query (doesn't ensure the
            # reader is open)
            ferret_index.synchronize do
              ferret_index.send(:ensure_reader_open)
              original_query = ferret_index.process_query(q)
            end if q.is_a? String

            q = Ferret::Search::BooleanQuery.new
            q.add_query(original_query, :must)
            model_query = Ferret::Search::BooleanQuery.new
            options[:models].each do |model|
              model_query.add_query(Ferret::Search::TermQuery.new(:class_name, model.name), :should)
            end
            q.add_query(model_query, :must)
          end
          #puts q.to_s
          total_hits = find_id_by_contents(q, options) do |model, id, score|
            o = Object.const_get(model).find(id, find_options.dup)
            o.ferret_score = score
            result << o
          end
          return SearchResults.new(result, total_hits)
        end
        protected :single_index_find_by_contents

        # return the total number of hits for the given query 
        def total_hits(q, options={})
          ferret_index.search(q, options).total_hits
        end

        # Finds instance model name, ids and scores by contents. 
        # Useful if you want to search across models
        # Terms are ANDed by default, can be circumvented by using OR between terms.
        #
        # Example controller code (not tested):
        # def multi_search(query)
        #   result = []
        #   result << (Model1.find_id_by_contents query)
        #   result << (Model2.find_id_by_contents query)
        #   result << (Model3.find_id_by_contents query)
        #   result.flatten!
        #   result.sort! {|element| element[:score]}
        #   # Figure out for yourself how to retreive and present the data from modelname and id 
        # end
        #
        # Note that the scores retrieved this way aren't normalized across
        # indexes, so that the order of results after sorting by score will
        # differ from the order you would get when running the same query
        # on a single index containing all the data from Model1, Model2 
        # and Model
        #
        # options are:
        #
        # first_doc::      first hit to retrieve (useful for paging)
        # num_docs::       number of hits to retrieve, or :all to retrieve all
        #                  results.
        #
        # a block can be given too, it will be executed with every result:
        # find_id_by_contents(q, options) do |model, id, score|
        #    id_array << id
        #    scores_by_id[id] = score 
        # end
        # NOTE: in case a block is given, the total_hits value will be returned
        # instead of the result list!
        # 
        def find_id_by_contents(q, options = {})
          deprecated_options_support(options)

          result = []
          index = self.ferret_index
          # puts "query: #{index.process_query q}"
          total_hits = index.search_each(q, options) do |hit, score|
            # only collect result data if we intend to return it
            doc = index[hit]
            model = configuration[:store_class_name] ? doc[:class_name] : self.name
            if block_given?
              yield model, doc[:id], score
            else
              result << { :model => model, :id => doc[:id], :score => score }
            end
          end
          logger.debug "id_score_model array: #{result.inspect}"
          return block_given? ? total_hits : result
        end
        
        # requires the store_class_name option of acts_as_ferret to be true
        # for all models queried this way.
        #
        # TODO: not optimal as each instance is fetched in a db call for it's
        # own.
        def multi_search(query, additional_models = [], options = {})
          result = []
          total_hits = id_multi_search(query, additional_models, options) do |model, id, score|
            r = Object.const_get(model).find(id)
            r.ferret_score = score
            result << r
          end
          SearchResults.new(result, total_hits)
        end
        
        # returns an array of hashes, each containing :class_name,
        # :id and :score for a hit.
        #
        # if a block is given, class_name, id and score of each hit will 
        # be yielded, and the total number of hits is returned.
        #
        def id_multi_search(query, additional_models = [], options = {})
          deprecated_options_support(options)
          additional_models = [ additional_models ] unless additional_models.is_a? Array
          additional_models << self
          searcher = multi_index(additional_models)
          result = []
          total_hits = searcher.search_each(query, options) do |hit, score|
            doc = searcher[hit]
            if block_given?
              yield doc[:class_name], doc[:id], score
            else
              result << { :model => doc[:class_name], :id => doc[:id], :score => score }
            end
          end
          return block_given? ? total_hits : result
        end
        
        # returns a MultiIndex instance operating on a MultiReader
        def multi_index(model_classes)
          model_classes.sort! { |a, b| a.name <=> b.name }
          key = model_classes.inject("") { |s, clazz| s << clazz.name }
          multi_config = ferret_configuration.dup
          multi_config.delete :default_field  # we don't want the default field list of *this* class for multi_searching
          @@multi_indexes[key] ||= MultiIndex.new(model_classes, multi_config)
        end

        private

        def deprecated_options_support(options)
          if options[:num_docs]
            logger.warn ":num_docs is deprecated, use :limit instead!"
            options[:limit] ||= options[:num_docs]
          end
          if options[:first_doc]
            logger.warn ":first_doc is deprecated, use :offset instead!"
            options[:offset] ||= options[:first_doc]
          end
        end

        # combine our conditions with those given by user, if any
        def combine_conditions(conditions, *additional_conditions)
          if additional_conditions.any?
            cust_opts = additional_conditions.dup.flatten
            conditions.first << " and " << cust_opts.shift
            conditions.concat(cust_opts)
          end
          conditions
        end

      end
      
    end
  end
end

