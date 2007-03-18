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

    def ayah_coverage_text(quranStruct)  
        if start_surah_num == end_surah_num
            "Surah #{quranStruct.get_surah(start_surah_num).name} Ayahs #{start_ayah_num} to #{end_ayah_num}"
        else
            "Surah #{quranStruct.get_surah(start_surah_num).name} Ayah #{start_ayah_num} to #{quranStruct.get_surah(end_surah_num).name} Ayah #{end_ayah_num}"
        end
    end

    PAGE_IMAGE_WIDTH = 456;
    SURA_NAME_BOX_HEIGHT = 115;
    ONE_LINE_HEIGHT = 45;
    MINIMUM_LINE_HEIGHT = 25;

    class AyahBoundingBox
        attr_accessor :left;
        attr_accessor :right;
        attr_accessor :top;
        attr_accessor :bottom;

        def initialize(x, y)
            if x < PAGE_IMAGE_WIDTH
              @left = x - 17
              @right = x + 17
            else
              @left = PAGE_IMAGE_WIDTH
              @right = PAGE_IMAGE_WIDTH
            end
            if y > 0
              @top = y - 7
              @bottom = y + 37
            else
              @top = 0
              @bottom = 0
            end
        end
    end

    class AyahsImageMapData
        attr_reader :surah_num
        attr_reader :ayah_num
        attr_reader :box

        def initialize(ayah, box)
            @surah_num = ayah.surah_num
            @ayah_num = ayah.ayah_num
            @box = box
        end
    end

    def create_image_map_data
        mapData = []

        self.ayahs.each do |ayah|
          # starting ayahs have the sura name block above them
          if ayah.ayah_num == 1
            startRect = AyahBoundingBox.new(PAGE_IMAGE_WIDTH, ayah.y_start + SURA_NAME_BOX_HEIGHT)
          else
            startRect = AyahBoundingBox.new(ayah.x_start, ayah.y_start)
          end
          endRect = AyahBoundingBox.new(ayah.x_end, ayah.y_end)

          # if the ayah doesn't start on the same line as it "number block", go to the next line
          if (startRect.left < 50) and (startRect.left > 0)
            startRect.left = PAGE_IMAGE_WIDTH
            startRect.right = PAGE_IMAGE_WIDTH
            startRect.top = startRect.top + ONE_LINE_HEIGHT
          end

          #ayahImgHeight = endRect.bottom - startRect.top;
          #if(ayahImgHeight >= MINIMUM_LINE_HEIGHT)
              mapData << AyahsImageMapData.new(ayah, endRect);
          #end
        end

        return mapData
    end
end
