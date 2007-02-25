# == Schema Information
# Schema version: 5
#
# Table name: quran_page_image
#
#  id           :integer(11)   not null, primary key
#  surah_num    :integer(11)   not null
#  ayah_num     :integer(11)   not null
#  page_num     :integer(11)   not null
#  xstart       :integer(11)   not null
#  xend         :integer(11)   not null
#  ystart       :integer(11)   not null
#  yend         :integer(11)   not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  lock_version :integer(11)   default(0), not null
#

class QuranPageImage < ActiveRecord::Base
  belongs_to :surahStruct, :class_name => "QuranStructSurah", :foreign_key => :surah_num
end
