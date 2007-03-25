class Quran::SearchController < QuranController
    def index
    end

    def search
        @query = params[:q]
        @results_summary = []

        if @query then
            @results_summary << SearchResults.new(self, QuranAyah.ferret_index_collection_name, QuranAyah.ferret_index, {}, { :field => :text }, [:quran_code, :surah_num, :ayah_num], "search_ayahs", "ayah_results")
            @results_summary << SearchResults.new(self, QuranSubject.ferret_index_collection_name, QuranSubject.ferret_index, {}, { :field => :topic }, [:quran_code, :id], "search_subjects", "subject_results")
            @results_summary << SearchResults.new(self, QuranAyahElaboration.ferret_index_collection_name, QuranAyahElaboration.ferret_index, {}, { :field => :text }, [:quran_code, :surah_num, :ayah_num, :note_id], "search_ayah_elaborations", "ayah_elaborations_results")
            @results_summary << SearchResults.new(self, QuranAyahsTheme.ferret_index_collection_name, QuranAyahsTheme.ferret_index, {}, { :field => :theme }, [:quran_code, :surah_num, :start_ayah_num, :end_ayah_num], "search_ayah_themes", "ayahs_theme_results")
            @results_summary << SearchResults.new(self, QuranSurah.ferret_index_collection_name, QuranSurah.ferret_index, {}, { :field => :overview_text }, [:quran_code, :surah_num], "search_surah_elaborations", "surah_elaboration_results")
        end
    end

    def search_ayahs
        @results = SearchResults.new(self, QuranAyah.ferret_index_collection_name, QuranAyah.ferret_index, {}, { :field => :text }, [:quran_code, :surah_num, :ayah_num], "search_ayahs", "ayah_results")
        render :template => "quran/search/search_collection"
    end

    def search_subjects
        @results = SearchResults.new(self, QuranSubject.ferret_index_collection_name, QuranSubject.ferret_index, {}, { :field => :topic }, [:quran_code, :id], "search_subjects", "subject_results")
        render :template => "quran/search/search_collection"
    end

    def search_ayah_elaborations
        @results = SearchResults.new(self, QuranAyahElaboration.ferret_index_collection_name, QuranAyahElaboration.ferret_index, {}, { :field => :text }, [:quran_code, :surah_num, :ayah_num, :note_id], "search_ayah_elaborations", "ayah_elaborations_results")
        render :template => "quran/search/search_collection"
    end

    def search_ayah_themes
        @results = SearchResults.new(self, QuranAyahsTheme.ferret_index_collection_name, QuranAyahsTheme.ferret_index, {}, { :field => :theme }, [:quran_code, :surah_num, :start_ayah_num, :end_ayah_num], "search_ayah_themes", "ayahs_theme_results")
        render :template => "quran/search/search_collection"
    end

    def search_surah_elaborations
        @results = SearchResults.new(self, "Surah Introduction (Translator Elaborations)", QuranSurah.ferret_index, {}, { :field => :overview_text }, [:quran_code, :surah_num], "search_surah_elaborations", "surah_elaboration_results")
        render :template => "quran/search/search_collection"
    end

    def query
        return params[:q]
    end

    def summarizing
        action_name == 'search'
    end

    def results_per_page
        Integer(params['rpp'] || 10)
    end

protected
    class SearchResults
        attr_accessor :controller
        attr_accessor :query
        attr_accessor :collection
        attr_accessor :collection_search_action
        attr_accessor :results
        attr_accessor :total_hits
        attr_accessor :renderer

        def initialize(controller, collection, index, query_options, excerpt_options, other_fields_to_assign, collection_search_action, renderer)
            @controller = controller
            @query = controller.query
            @collection = collection
            @collection_search_action = collection_search_action
            @renderer = renderer
            @total_hits, @results = full_text_search_by_storage(index, @query, query_options, excerpt_options, other_fields_to_assign)
        end

        def pages
            @pages ||= pages_for(@total_hits)
        end

    protected
        def pages_for(size, options = {})
            default_options = {:per_page => @controller.results_per_page}
            options = default_options.merge options
            pages = ActionController::Base::Paginator.new self, size, options[:per_page], (@controller.params[:page]||1)
            return pages
        end

        def full_text_search_by_storage(index, query, query_options = {}, excerpt_options = {}, other_fields_to_assign = [])
            return nil if query.nil? or query == ""

            default_query_options = {:limit => @controller.summarizing ? 5 : @controller.results_per_page, :page => @controller.summarizing ? 1 : (@controller.params[:page] || 1) }
            query_options = default_query_options.merge query_options

            # get the offset based on what page we're on
            query_options[:offset] = query_options[:limit] * (query_options.delete(:page).to_i-1)

            default_excerpt_options = {
                # be sure to supply :field through excerpt_options
                :pre_tag => "<strong>",
                :post_tag => "</strong>",
                :num_excerpts => 1
            }
            excerpt_options = default_excerpt_options.merge excerpt_options

            results = []
            puts excerpt_options


            # search_each is the core search function from Ferret, which Acts_as_ferret hides
            total_hits = index.search_each(query, query_options) do |doc, score|
                result = {}

                # Store each field in a hash which we can reference in our views
                other_fields_to_assign.each do |field|
                    result[field] = index[doc][field]
                end
                result[:excerpt] = index.highlight(query, doc, excerpt_options)
                result[:score] = score unless result[:score]

                results.push result
            end
            return block_given? ? total_hits : [total_hits, results]
        end
    end
end
