# == Schema Information
# Schema version: 2
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
end
