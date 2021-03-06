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
    acts_as_ferret :fields => { :theme => {:store => :yes}, :quran_code => { :store => :yes }, :surah_num => { :store => :yes }, :start_ayah_num => { :store => :yes }, :end_ayah_num => { :store => :yes } }

    def quran_code
        return surah.quran.code
    end

    def surah_num
        return surah.surah_num
    end

    def self.ferret_index_collection_name
        "Qur'an Ayahs Themes"
    end
end
