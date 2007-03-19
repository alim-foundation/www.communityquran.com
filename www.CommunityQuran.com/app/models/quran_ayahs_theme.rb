# == Schema Information
# Schema version: 1
#
# Table name: quran_ayahs_theme
#
#  id             :integer(11)   not null, primary key
#  quran_surah_id :integer(11)   not null
#  start_ayah_num :integer(11)   not null
#  end_ayah_num   :integer(11)   not null
#  theme          :text          not null
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  lock_version   :integer(11)   default(0), not null
#

class QuranAyahsTheme < ActiveRecord::Base
    belongs_to :surah, :class_name => "QuranSurah"
    acts_as_ferret :fields => { :theme => {:store => :yes} }
    acts_as_ferret :fields => { :theme => {:store => :yes}, :surah_num => { :store => :yes }, :start_ayah_num => { :store => :yes }, :end_ayah_num => { :store => :yes } }

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
