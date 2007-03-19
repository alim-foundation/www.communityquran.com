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
    acts_as_ferret :fields => [:overview]    

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
end
