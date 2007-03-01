# == Schema Information
# Schema version: 2
#
# Table name: quran_page_image
#
#  id           :integer(11)   not null, primary key
#  quran_id     :integer(11)   not null
#  page_num     :integer(11)   not null
#  surah_num    :integer(11)   not null
#  ayah_num     :integer(11)   not null
#  x_start      :integer(11)   not null
#  x_end        :integer(11)   not null
#  y_start      :integer(11)   not null
#  y_end        :integer(11)   not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  lock_version :integer(11)   default(0), not null
#

class QuranPageImage < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
end
