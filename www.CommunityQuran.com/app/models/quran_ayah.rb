# == Schema Information
# Schema version: 1
#
# Table name: quran_ayah
#
#  id             :integer(11)   not null, primary key
#  quran_id       :integer(11)   not null
#  quran_surah_id :integer(11)   not null
#  surah_num      :integer(11)   not null
#  ayah_num       :integer(11)   not null
#  text           :text          not null
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  lock_version   :integer(11)   default(0), not null
#

class QuranAyah < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
    belongs_to :surah, :class_name => "QuranSurah"
    has_many :elaborations, :class_name => "QuranAyahElaboration"
    acts_as_ferret :fields => { :text => {:store => :yes}, :quran_code => { :store => :yes }, :surah_num => { :store => :yes }, :ayah_num => { :store => :yes } }

    def quran_code
        return quran.code
    end

    def anchor_name
        "S#{surah_num}A#{ayah_num}"
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
end
