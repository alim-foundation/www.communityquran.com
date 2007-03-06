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

    def is_first
        return page_num == 1
    end

    def previous_page_num
        return page_num == 1 ? 604 : page_num - 1  
    end

    def next_page_num
        return is_last ? 1 : page_num + 1
    end

    def is_last
        return page_num == 604
    end
end
