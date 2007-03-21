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
    acts_as_ferret :fields => { :overview => {:store => :yes}, :overview_text => {:store => :yes}, :quran_code => { :store => :yes, }, :surah_num => { :store => :yes } }

    def quran_code
        quran.code
    end

    def self.ferret_index_collection_name
        "Qur'an Surah Introductions (Overview/Elaborations)"
    end

    def overview_text
        # this is stored in the full-text search index so don't store any HTML (strip HTML)
        overview.gsub(/<\/?[^>]*>/, "")
    end
end
