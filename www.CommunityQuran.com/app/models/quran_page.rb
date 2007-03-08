# == Schema Information
# Schema version: 1
#
# Table name: quran_page
#
#  id              :integer(11)   not null, primary key
#  quran_id        :integer(11)   not null
#  page_num        :integer(11)   not null
#  start_surah_num :integer(11)   not null
#  start_ayah_num  :integer(11)   not null
#  end_surah_num   :integer(11)   not null
#  end_ayah_num    :integer(11)   not null
#  created_at      :datetime      not null
#  updated_at      :datetime      not null
#  lock_version    :integer(11)   default(0), not null
#

class QuranPage < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
    has_many :ayahs, :class_name => "QuranPageAyah"

    def ayah_coverage_text
        if start_surah_num == end_surah_num
            "Surah #{QuranHelper::QURAN_STRUCT.get_surah(start_surah_num).name} Ayahs #{start_ayah_num} to #{end_ayah_num}"
        else
            "Surah #{QuranHelper::QURAN_STRUCT.get_surah(start_surah_num).name} Ayah #{start_ayah_num} to #{QuranHelper::QURAN_STRUCT.get_surah(end_surah_num).name} Ayah #{end_ayah_num}"
        end
    end
end
