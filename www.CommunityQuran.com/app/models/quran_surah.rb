# == Schema Information
# Schema version: 2
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
    acts_as_ferret :fields => [:overview]    
end
