# == Schema Information
# Schema version: 1
#
# Table name: quran_surah
#
#  id           :integer(11)   not null, primary key
#  quran_id     :integer(11)   not null
#  surah_num    :integer(11)   not null
#  overview     :text          
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  lock_version :integer(11)   default(0), not null
#

class QuranSurah < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
    belongs_to :surahStruct, :class_name => "QuranStructSurah", :foreign_key => :surah_num
    has_many :ayahs, :class_name => "QuranAyah"
    has_many :themes, :class_name => "QuranAyahsTheme"
    acts_as_ferret :fields => { :overview => {:store => :yes}, :quran_code => { :store => :yes, }, :surah_num => { :store => :yes } }

    def quran_code
        return quran.code
    end

    def self.full_text_search(q, options = {})
        return nil if q.nil? or q==""
        default_options = {:limit => 10, :page => 1}
        options = default_options.merge options

        # get the offset based on what page we're on
        options[:offset] = options[:limit] * (options.delete(:page).to_i-1)

        # now do the query with our options
        results = self.find_by_contents(q, options)
        return [results.total_hits, results]
    end

    def self.full_text_search_by_storage(query, options = {})
        index = self.ferret_index # Get the index that acts_as_ferret created for us
        results = []

        # search_each is the core search function from Ferret, which Acts_as_ferret hides
        total_hits = index.search_each(query, options) do |doc, score|
            result = {}

            # Store each field in a hash which we can reference in our views
            result[:quran_code] = index[doc][:quran_code]
            result[:surah_num] = index[doc][:surah_num]
            result[:excerpt] = index.highlight(query, doc,
                                               :field => :overview,
                                               :pre_tag => "<strong>",
                                               :post_tag => "</strong>",
                                               :num_excerpts => 1)
            result[:score] = score   # We can even put the score in the hash, nice!

            results.push result
        end
        return block_given? ? total_hits : [total_hits, results]
    end

end
