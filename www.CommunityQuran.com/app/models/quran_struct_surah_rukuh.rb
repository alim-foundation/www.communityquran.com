# == Schema Information
# Schema version: 1
#
# Table name: quran_struct_surah_rukuh
#
#  id             :integer(11)   not null, primary key
#  surah_num      :integer(11)   not null
#  rukuh_num      :integer(11)   not null
#  start_ayah_num :integer(11)   not null
#  end_ayah_num   :integer(11)   not null
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  lock_version   :integer(11)   default(0), not null
#

class QuranStructSurahRukuh < ActiveRecord::Base
    belongs_to :surah, :class_name => "QuranStructSurah", :foreign_key => :surah_num

    def ayah_coverage_text
        "Surah #{QuranHelper::SURAH_STRUCTS[start_surah_num-1].name} Ayahs #{start_ayah_num} to #{end_ayah_num}"
    end
end
