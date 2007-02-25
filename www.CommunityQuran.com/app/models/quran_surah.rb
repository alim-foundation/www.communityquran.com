# == Schema Information
# Schema version: 5
#
# Table name: quran_surah
#
#  id           :integer(11)   not null, primary key
#  quran_id     :integer(11)   not null
#  surah_num    :integer(11)   not null
#  overview     :text          
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  lock_version :integer(11)   default(0), not null
#

class QuranSurah < ActiveRecord::Base
  belongs_to :quran, :class_name => "Quran"
  belongs_to :surahStruct, :class_name => "QuranStructSurah", :foreign_key => :surah_num
  has_many :ayahs, :class_name => "QuranAyah"
  has_many :themes, :class_name => "QuranAyahsTheme"

  def import_from_xml(surahElem, isSuraInfo)
      self.surah_num = surahElem.attributes['num']
      
      if isSuraInfo
        surahElem.name = "div"
        surahElem.add_attribute("class", "surah-overview")
        
        # switch <section> tags to be <div class='section'>
        surahElem.elements.each('section') do |e|
          e.name = 'div'
          e.add_attribute("class", "section")
          heading = e.attributes["heading"]
          e.delete_attribute("heading")
          h1 = REXML::Element.new 'div'
          h1.add_attribute('class', 'heading')
          h1.add_text heading
          e.insert_before(e[0], h1)
        end
        
        self.overview = surahElem.children.to_s
        save!
      else      
        save!
        surahElem.elements.each('ayah') do |ayahElem|
          self.ayahs.build.import_from_xml(ayahElem)
        end
      end
  end
end
