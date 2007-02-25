require 'rexml/document'

class LoadQuran < ActiveRecord::Migration
  def self.up
    #Quran.new.import_from_xml(File.new('data/Quran/Malik Sura Introductions.xml'))
    #Quran.new.import_from_xml(File.new('data/Quran/Yusuf Ali Translation.xml'))
  end

  def self.down
  end
end
