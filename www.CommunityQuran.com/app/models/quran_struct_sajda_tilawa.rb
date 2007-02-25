# == Schema Information
# Schema version: 5
#
# Table name: quran_struct_sajda_tilawa
#
#  sajda_num    :integer(11)   not null, primary key
#  surah_num    :integer(11)   not null
#  ayah_num     :integer(11)   not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  lock_version :integer(11)   default(0), not null
#

class QuranStructSajdaTilawa < ActiveRecord::Base
  self.primary_key = "sajda_num"
end
