# == Schema Information
# Schema version: 2
#
# Table name: quran_ayah_elaboration
#
#  id            :integer(11)   not null, primary key
#  quran_ayah_id :integer(11)   not null
#  num           :integer(11)   
#  code          :string(255)   
#  text          :text          not null
#  created_at    :datetime      not null
#  updated_at    :datetime      not null
#  lock_version  :integer(11)   default(0), not null
#

class QuranAyahElaboration < ActiveRecord::Base
    belongs_to :ayah, :class_name => "QuranAyah"
    acts_as_ferret :fields => [:text]    
end
