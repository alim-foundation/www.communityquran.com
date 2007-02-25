class CreateQuranStructure < ActiveRecord::Migration
  def self.up
    create_table :quran_struct_surah, :primary_key => :surah_num do |t|
      t.column :name, :string, :null => false
      t.column :ayah_count, :integer, :null => false
      t.column :revealed_num, :integer, :null => false
      t.column :revealed_city, :string, :null => false
    end

    create_table :quran_struct_surah_ruku do |t|
      t.column :surah_num, :integer, :null => false
      t.column :ruku_num, :integer, :null => false
      t.column :start_ayah_num, :integer, :null => false
      t.column :end_ayah_num, :integer, :null => false
      
      t.foreign_key :surah_num, :quran_struct_surah, :surah_num
    end    

    create_table :quran_struct_juz, :primary_key => :juz_num do |t|
      t.column :surah_num, :integer, :null => false
      t.column :ayah_num, :integer, :null => false

      t.foreign_key :surah_num, :quran_struct_surah, :surah_num
    end

    create_table :quran_struct_sajda_tilawa, :primary_key => :sajda_num do |t|
      t.column :surah_num, :integer, :null => false
      t.column :ayah_num, :integer, :null => false

      t.foreign_key :surah_num, :quran_struct_surah, :surah_num
    end
  end

  def self.down
    drop_table :quran_struct_surah
    drop_table :quran_struct_surah_ruku
    drop_table :quran_struct_juz
    drop_table :quran_struct_sajda_tilawa
  end
end
