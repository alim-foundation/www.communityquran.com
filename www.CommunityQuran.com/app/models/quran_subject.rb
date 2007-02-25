# == Schema Information
# Schema version: 5
#
# Table name: quran_subject
#
#  id              :integer(11)   not null, primary key
#  quran_id        :integer(11)   not null
#  parent_id       :integer(11)   
#  topic           :string(384)   not null
#  full_topic_path :string(1024)  not null
#  created_at      :datetime      not null
#  updated_at      :datetime      not null
#  lock_version    :integer(11)   default(0), not null
#

class QuranSubject < ActiveRecord::Base
  belongs_to :quran, :class_name => "Quran"
  has_many :subtopics, :class_name => "QuranSubject", :foreign_key => :parent_id
  has_many :locations, :class_name => "QuranSubjectLocation"
end