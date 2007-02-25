require 'rexml/document'

class LoadQuranStructure < ActiveRecord::Migration
  def self.up
    down

    surahCount = 0;
    quranStruct = REXML::Document.new(File.new('data/Quran/Quran Structure.xml'))
    quranStruct.elements.each('aml/quran/suras/sura') do |surahElem|
      surah = QuranStructSurah.create(
          :surah_num => surahElem.attributes['num'],
          :name => surahElem.elements['name'].text,
          :ayah_count => surahElem.attributes['ayahcount'],
          :revealed_num => surahElem.elements['revealed'].attributes['num'],
          :revealed_city => surahElem.elements['revealed'].attributes['city']);
      
      surahElem.elements.each('rukus/ruku') do |rukuElem|
        ruku = surah.rukus.create(
          :ruku_num => rukuElem.attributes['num'],          
          :start_ayah_num => rukuElem.attributes['startayah'],
          :end_ayah_num => rukuElem.attributes['endayah']          
        );
      end
      
      surahCount += 1
    end
    puts "Saved #{surahCount} Surah definitions.\n"

    sajdaCount = 0
    quranStruct.elements.each('aml/quran/sajdatilawa/sajda') do |sajdaElem|
      sajda = QuranStructSajdaTilawa.create(
          :surah_num => sajdaElem.attributes['sura'],
          :ayah_num => sajdaElem.attributes['ayah']);

      sajdaCount += 1
    end
    puts "Saved #{sajdaCount} Sajda Tilawa definitions.\n"

    juzCount = 0
    quranStruct.elements.each('aml/quran/ajza/juz') do |juzElem|
      juz = QuranStructJuz.create(
          :surah_num => juzElem.attributes['sura'],
          :ayah_num => juzElem.attributes['ayah']);

      juzCount += 1
    end
    puts "Saved #{juzCount} Juz definitions.\n"
  end

  def self.down
    QuranStructSurah.delete_all
    QuranStructSurahRuku.delete_all
    QuranStructSajdaTilawa.delete_all
    QuranStructJuz.delete_all
  end
end
