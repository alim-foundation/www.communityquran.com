class CreateQuran < ActiveRecord::Migration
  def self.up
    create_table :quran_page_image do |t|
      t.column :surah_num, :integer, :null => false        
      t.column :ayah_num, :integer, :null => false        
      t.column :page_num, :integer, :null => false        
      t.column :xstart, :integer, :null => false        
      t.column :xend, :integer, :null => false        
      t.column :ystart, :integer, :null => false        
      t.column :yend, :integer, :null => false

      t.foreign_key :surah_num, :quran_struct_surah, :surah_num
    end  

    create_table :quran do |t|
      t.column :code, :string, :limit => 16, :null => false
      t.column :short_name, :string, :null => false
      t.column :full_name, :string, :null => false
      t.column :author, :string
      t.column :description, :text
      t.column :contains_surah_elaborations, :boolean
      t.column :contains_ayahs, :boolean
      t.column :contains_ayah_elaborations, :boolean
      t.column :contains_ayah_themes, :boolean
      t.column :contains_subjects, :boolean
    end
    add_index :quran, :code, :name => "unique_quran_code", :unique => true
    add_index :quran, :short_name, :name => "unique_quran_short_name", :unique => true
    add_index :quran, :full_name, :name => "unique_quran_full_name", :unique => true
  
    create_table :quran_surah do |t|
      t.column :quran_id, :integer, :null => false
      t.column :surah_num, :integer, :null => false        
      t.column :overview, :text

      t.foreign_key :surah_num, :quran_struct_surah, :surah_num
    end  
  
    create_table :quran_ayah do |t|
      t.column :quran_surah_id, :integer, :null => false
      t.column :ayah_num, :integer, :null => false
      t.column :text, :text, :null => false
    end

    create_table :quran_ayah_elaboration do |t|
      t.column :quran_ayah_id, :integer, :null => false
      t.column :num, :integer
      t.column :code, :string
      t.column :text, :text, :null => false
    end

    create_table :quran_ayahs_theme do |t|
      t.column :quran_surah_id, :integer, :null => false
      t.column :start_ayah_num, :integer, :null => false
      t.column :end_ayah_num, :integer, :null => false
      t.column :theme, :text, :null => false
    end
    
    create_table :quran_subject do |t|
      t.column :quran_id, :integer, :null => false
      t.column :parent_id, :integer, :references => :quran_subject
      t.column :topic, :string, :limit => 384, :null => false
      t.column :full_topic_path, :string, :limit => 1024, :null => false      # combination of topic::subtopic::subtopic, etc
    end
    #TODO: create a unique index -- mysql is erroring saying that the index size is being exceeded; see http://dev.mysql.com/doc/mysql/en/CREATE_INDEX.html
    #add_index :quran_subject, [:quran_id, :full_topic_path], :name => "unique_quran_subject", :unique => true

    create_table :quran_subject_location do |t|
      t.column :quran_subject_id, :integer, :references => :quran_subject
      t.column :surah_num, :integer, :null => false
      t.column :ayah_num, :integer

      t.foreign_key :surah_num, :quran_struct_surah, :surah_num
    end      
  end

  def self.down
    drop_table :quran_page_image
    drop_table :quran
    drop_table :quran_surah
    drop_table :quran_ayah
    drop_table :quran_ayah_elaboration
    drop_table :quran_ayahs_theme
    drop_table :quran_subject
    drop_table :quran_subject_location
  end
end
