# == Schema Information
# Schema version: 1
#
# Table name: quran_struct
#
#  id           :integer(11)   not null, primary key
#  surah_count  :integer(11)   not null
#  juz_count    :integer(11)   not null
#  sajda_count  :integer(11)   not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  lock_version :integer(11)   default(0), not null
#

class QuranStruct < ActiveRecord::Base
    has_many :ajza, :class_name => "QuranStructJuz"
    has_many :sajdas, :class_name => "QuranStructSajdaTilawa"
    has_many :surahs, :class_name => "QuranStructSurah"

    def get_surah(surahNum)
        return surahs[surahNum-1]
    end
end
