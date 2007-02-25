# == Schema Information
# Schema version: 5
#
# Table name: quran_struct_surah
#
#  surah_num     :integer(11)   not null, primary key
#  name          :string(255)   not null
#  ayah_count    :integer(11)   not null
#  revealed_num  :integer(11)   not null
#  revealed_city :string(255)   not null
#  created_at    :datetime      not null
#  updated_at    :datetime      not null
#  lock_version  :integer(11)   default(0), not null
#

class QuranStructSurah < ActiveRecord::Base
  self.primary_key = "surah_num"

  has_many :rukus, :class_name => "QuranStructSurahRuku", :foreign_key => :sura_num
  has_many :ajza, :class_name => "QuranStructJuz", :foreign_key => :sura_num
  has_many :sajdas, :class_name => "QuranStructSajdaTilawa", :foreign_key => :sura_num
  has_many :surahs, :class_name => "QuranSurah", :foreign_key => :sura_num
  has_many :pages, :class_name => "QuranPageImage", :foreign_key => :sura_num
end
