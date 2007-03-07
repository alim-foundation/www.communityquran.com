# == Schema Information
# Schema version: 1
#
# Table name: quran_ayah
#
#  id             :integer(11)   not null, primary key
#  quran_id       :integer(11)   not null
#  quran_surah_id :integer(11)   not null
#  surah_num      :integer(11)   not null
#  ayah_num       :integer(11)   not null
#  text           :text          not null
#  created_at     :datetime      not null
#  updated_at     :datetime      not null
#  lock_version   :integer(11)   default(0), not null
#

class QuranAyah < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
    belongs_to :surah, :class_name => "QuranSurah"
    has_many :elaborations, :class_name => "QuranAyahElaboration"
    acts_as_ferret :fields => [:text]
end
