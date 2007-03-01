# == Schema Information
# Schema version: 2
#
# Table name: quran_page_images_info
#
#  id                     :integer(11)   not null, primary key
#  quran_id               :integer(11)   not null
#  page_image_name_format :string(255)   
#  image_width            :integer(11)   
#  line_height            :integer(11)   
#  min_line_height        :integer(11)   
#  created_at             :datetime      not null
#  updated_at             :datetime      not null
#  lock_version           :integer(11)   default(0), not null
#

class QuranPageImagesInfo < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
end
