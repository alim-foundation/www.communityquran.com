# == Schema Information
# Schema version: 5
#
# Table name: quran
#
#  id                          :integer(11)   not null, primary key
#  code                        :string(16)    not null
#  short_name                  :string(255)   not null
#  full_name                   :string(255)   not null
#  author                      :string(255)   
#  description                 :text          
#  contains_surah_elaborations :boolean(1)    
#  contains_ayahs              :boolean(1)    
#  contains_ayah_elaborations  :boolean(1)    
#  contains_ayah_themes        :boolean(1)    
#  contains_subjects           :boolean(1)    
#  created_at                  :datetime      not null
#  updated_at                  :datetime      not null
#  lock_version                :integer(11)   default(0), not null
#

require 'rexml/document'

class Quran < ActiveRecord::Base
  has_many :surahs, :class_name => "QuranSurah"
  has_many :subjects, :class_name => "QuranSubject"
  
  def get_subject(topic, subtopic)
    #self.subjects.find_by_full_topic_path(:first)
  end
  
  def import_from_xml(source)
    doc = REXML::Document.new(source)
    
    isSuraInfo = false
    catalogElem = doc.elements['aml/quran/catalog']
    
    if catalogElem.nil?
      catalogElem = doc.elements['aml/surainfo/catalog']
      isSuraInfo = true
    end
    
    namesElem = catalogElem.elements['names'];
    
    self.code = catalogElem.attributes['id'];
    self.short_name = namesElem.attributes['short'];
    self.full_name = namesElem.attributes['full'];    
    save!
    
    puts "Importing #{full_name} (#{code}, #{short_name}) from #{source.to_s}.\n"    
    
    doc.elements.each(isSuraInfo ? 'aml/surainfo/sura[@num = 1]' : 'aml/quran/sura[@num = 1]') do |surahElem|
      surah = self.surahs.build.import_from_xml(surahElem, isSuraInfo)
      puts "  Imported #{short_name} Surah #{surahElem.attributes['num']}.\n"    
    end    
    puts "  Done importing from #{source.to_s}.\n"    
  end
end
