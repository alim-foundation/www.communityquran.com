# == Schema Information
# Schema version: 2
#
# Table name: quran_subject_location
#
#  id               :integer(11)   not null, primary key
#  quran_subject_id :integer(11)   
#  surah_num        :integer(11)   not null
#  ayah_num         :integer(11)   
#  created_at       :datetime      not null
#  updated_at       :datetime      not null
#  lock_version     :integer(11)   default(0), not null
#

class QuranSubjectLocation < ActiveRecord::Base
    belongs_to :quran_subject, :class_name => "QuranSubject"
end
