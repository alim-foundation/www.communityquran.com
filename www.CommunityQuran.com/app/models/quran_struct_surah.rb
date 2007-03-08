# == Schema Information
# Schema version: 1
#
# Table name: quran_struct_surah
#
#  surah_num       :integer(11)   not null, primary key
#  quran_struct_id :integer(11)   not null
#  name            :string(255)   not null
#  ayah_count      :integer(11)   not null
#  rukuh_count     :integer(11)   not null
#  revealed_num    :integer(11)   not null
#  revealed_city   :string(255)   not null
#  created_at      :datetime      not null
#  updated_at      :datetime      not null
#  lock_version    :integer(11)   default(0), not null
#

class QuranStructSurah < ActiveRecord::Base
    self.primary_key = "surah_num"

    belongs_to :struct, :class_name => "QuranStruct"
    
    has_many :rukuhs, :class_name => "QuranStructSurahRukuh", :foreign_key => :surah_num
    has_many :ajza, :class_name => "QuranStructJuz", :foreign_key => :surah_num
    has_many :sajdas, :class_name => "QuranStructSajdaTilawa", :foreign_key => :surah_num
end
