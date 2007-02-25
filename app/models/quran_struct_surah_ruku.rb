# == Schema Information
# Schema version: 5
#
# Table name: quran_struct_surah_ruku
#
#  id             :integer(11)   not null, primary key
#  surah_num      :integer(11)   not null
#  ruku_num       :integer(11)   not null
#  start_ayah_num :integer(11)   not null
#  end_ayah_num   :integer(11)   not null
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  lock_version   :integer(11)   default(0), not null
#

class QuranStructSurahRuku < ActiveRecord::Base
  belongs_to :surah, :class_name => "QuranStructSurah", :foreign_key => :surah_num
end
