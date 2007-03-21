# == Schema Information
# Schema version: 1
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
    acts_as_ferret :fields => { :text => {:store => :yes}, :quran_code => { :store => :yes }, :note_id => { :store => :yes }, :surah_num => { :store => :yes }, :ayah_num => { :store => :yes } }

    def quran_code
        return ayah.quran.code
    end

    def surah_num
        return ayah.surah_num
    end

    def ayah_num
        return ayah.ayah_num
    end

    def note_id
        num || code
    end

    def self.ferret_index_collection_name
        "Qur'an Ayah Translator Commentary/Elaborations"
    end
end
