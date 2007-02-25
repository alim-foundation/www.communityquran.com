# == Schema Information
# Schema version: 5
#
# Table name: quran_ayah
#
#  id             :integer(11)   not null, primary key
#  quran_surah_id :integer(11)   not null
#  ayah_num       :integer(11)   not null
#  text           :text          not null
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  lock_version   :integer(11)   default(0), not null
#

class QuranAyah < ActiveRecord::Base
  belongs_to :surah, :class_name => "QuranSurah"
  has_many :elaborations, :class_name => "QuranAyahElaboration"

  def import_from_xml(ayahElem)
      # copy all the elaboration elements into an array so that we can remove them safely
      # since we want to grab the ayah element's text and all tags without grabbing notes
      elaborationElems = {}
      ayahElem.elements.each('note') do |noteElem|
        noteElem.name = "div";
        noteElem.add_attribute("class", "note");
        elaborationElems[noteElem.attributes['id']] = noteElem.to_s
      end
      ayahElem.elements.delete('note')

      #TODO: copy all the index elements into an array so that we can remove them safely
      #ayahElem.elements.each('index') do |indexElem|
      #  topic = self.surah.quran.subjects.find(:first, :conditions => ['topic = ? and parent_topic_id is null', indexElem.attributes['topic']])
      #end
      #ayahElem.elements.delete('index')

      # we've stripped out all the notes and index tags so all that's left is ayah text so save it
      self.ayah_num = ayahElem.attributes['num']
      ayahElem.name = "div"
      ayahElem.add_attribute("class", "ayah")
      
      # switch <fn> tags to be <span class='fn'>
      surahElem.elements.each('fn') do |e|
        e.name = 'span'
        e.add_attribute("class", "fn")
      end
            
      self.text = ayahElem.to_s
      save!
      
      # now store the notes separately
      elaborationElems.keys.each do |noteId|
        self.elaborations.create(:code => noteId, :text => elaborationElems[noteId])
      end
  end
end
