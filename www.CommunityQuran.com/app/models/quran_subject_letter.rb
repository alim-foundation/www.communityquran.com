# == Schema Information
# Schema version: 1
#
# Table name: quran_subject_letter
#
#  id           :integer(11)   not null, primary key
#  quran_id     :integer(11)   not null
#  letter       :string(3)     not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  lock_version :integer(11)   default(0), not null
#

class QuranSubjectLetter < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
    has_many :subjects, :class_name => "QuranSubject"
end
