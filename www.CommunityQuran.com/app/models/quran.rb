# == Schema Information
# Schema version: 1
#
# Table name: quran
#
#  id                          :integer(11)   not null, primary key
#  code                        :string(16)    not null
#  short_name                  :string(255)   not null
#  full_name                   :string(255)   not null
#  author                      :string(255)   
#  description                 :text          
#  contains_page_images        :boolean(1)    
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
    has_many :ayahs, :class_name => "QuranAyah"
    has_many :subjects, :class_name => "QuranSubject"
    has_one :page_images_info, :class_name => "QuranPageImagesInfo"
    has_many :pages, :class_name => "QuranPage"
    has_many :page_ayahs, :class_name => "QuranPageAyah"

    def add_subject_location(topic, subtopic, surah_num, ayah_num)
        if subtopic
            fullPath = "#{topic}::#{subtopic}"
            subject = subjects.find_by_full_topic_path(fullPath)
            if subject
                subject.locations.create(:surah_num => surah_num, :ayah_num => ayah_num)
            else
                subject = subjects.find_by_topic_and_parent_id(topic, nil) ||
                          subjects.create(:topic => topic, :full_topic_path => topic)
                subject.locations.create(:surah_num => surah_num, :ayah_num => ayah_num) unless subject.locations.find_by_surah_num_and_ayah_num(surah_num, ayah_num)

                child = subject.children.create(:quran_id => subject.quran_id, :topic => subtopic, :full_topic_path => fullPath)
                child.locations.create(:surah_num => surah_num, :ayah_num => ayah_num)
            end
        else
            subject = subjects.find_by_topic_and_parent_id(topic, nil) ||
                      subjects.create(:topic => topic, :full_topic_path => topic)
            subject.locations.create(:surah_num => surah_num, :ayah_num => ayah_num) unless subject.locations.find_by_surah_num_and_ayah_num(surah_num, ayah_num)
        end
    end
end
