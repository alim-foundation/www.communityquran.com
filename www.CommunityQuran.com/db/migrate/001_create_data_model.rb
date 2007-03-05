class CreateDataModel < ActiveRecord::Migration
    def self.up
        create_tables
        import_quran_structure_data
    end

    def self.create_tables
        create_table :system_setting do |t|
            t.column :name,   :string,  :null => false, :limit => 255
            t.column :value,  :text,    :null => false
        end
        add_index :system_setting, [:name], :unique => true

        # see the basic environment data we need to run in development mode (needed by environment_check plugin)
        SystemSetting.create(:name => 'environment', :value => 'development')

        create_table :quran_struct_surah, :primary_key => :surah_num do |t|
            t.column :name, :string, :null => false
            t.column :ayah_count, :integer, :null => false
            t.column :ruku_count, :integer, :null => false
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

        create_table :quran do |t|
            t.column :code, :string, :limit => 16, :null => false
            t.column :short_name, :string, :null => false
            t.column :full_name, :string, :null => false
            t.column :author, :string
            t.column :description, :text
            t.column :contains_page_images, :boolean
            t.column :contains_surah_elaborations, :boolean
            t.column :contains_ayahs, :boolean
            t.column :contains_ayah_elaborations, :boolean
            t.column :contains_ayah_themes, :boolean
            t.column :contains_subjects, :boolean
        end
        add_index :quran, :code, :name => "unique_quran_code", :unique => true
        add_index :quran, :short_name, :name => "unique_quran_short_name", :unique => true
        add_index :quran, :full_name, :name => "unique_quran_full_name", :unique => true

        create_table :quran_page_images_info do |t|
            t.column :quran_id, :integer, :null => false, :on_delete => :cascade
            t.column :page_image_name_format, :string
            t.column :image_width, :integer
            t.column :line_height, :integer
            t.column :min_line_height, :integer
        end

        create_table :quran_page_image do |t|
            t.column :quran_id, :integer, :null => false, :on_delete => :cascade
            t.column :page_num, :integer, :null => false
            t.column :surah_num, :integer, :null => false
            t.column :ayah_num, :integer, :null => false
            t.column :x_start, :integer, :null => false
            t.column :x_end, :integer, :null => false
            t.column :y_start, :integer, :null => false
            t.column :y_end, :integer, :null => false

            t.foreign_key :surah_num, :quran_struct_surah, :surah_num
        end

        create_table :quran_surah do |t|
            t.column :quran_id, :integer, :null => false, :on_delete => :cascade
            t.column :surah_num, :integer, :null => false
            t.column :overview, :text

            t.foreign_key :surah_num, :quran_struct_surah, :surah_num
        end

        create_table :quran_ayah do |t|
            t.column :quran_surah_id, :integer, :null => false, :on_delete => :cascade
            t.column :ayah_num, :integer, :null => false
            t.column :text, :text, :null => false
        end

        create_table :quran_ayah_elaboration do |t|
            t.column :quran_ayah_id, :integer, :null => false, :on_delete => :cascade
            t.column :num, :integer
            t.column :code, :string
            t.column :text, :text, :null => false
        end

        create_table :quran_ayahs_theme do |t|
            t.column :quran_surah_id, :integer, :null => false, :on_delete => :cascade
            t.column :start_ayah_num, :integer, :null => false
            t.column :end_ayah_num, :integer, :null => false
            t.column :theme, :text, :null => false
        end

        create_table :quran_subject do |t|
            t.column :quran_id, :integer, :null => false, :on_delete => :cascade
            t.column :parent_id, :integer, :references => :quran_subject, :on_delete => :cascade
            t.column :topic, :string, :limit => 384, :null => false
            t.column :full_topic_path, :string, :limit => 1024, :null => false      # combination of topic::subtopic::subtopic, etc
        end
        #TODO: create a unique index -- mysql is erroring saying that the index size is being exceeded; see http://dev.mysql.com/doc/mysql/en/CREATE_INDEX.html
        #add_index :quran_subject, [:quran_id, :full_topic_path], :name => "unique_quran_subject", :unique => true

        create_table :quran_subject_location do |t|
            t.column :quran_subject_id, :integer, :references => :quran_subject, :on_delete => :cascade
            t.column :surah_num, :integer, :null => false
            t.column :ayah_num, :integer

            t.foreign_key :surah_num, :quran_struct_surah, :surah_num
        end
    end

    def self.down
        drop_table :system_setting
        drop_table :quran_struct_surah
        drop_table :quran_struct_surah_ruku
        drop_table :quran_struct_juz
        drop_table :quran_struct_sajda_tilawa
        drop_table :quran_page_image
        drop_table :quran
        drop_table :quran_surah
        drop_table :quran_ayah
        drop_table :quran_ayah_elaboration
        drop_table :quran_ayahs_theme
        drop_table :quran_subject
        drop_table :quran_subject_location
    end

    def self.import_quran_structure_data
        surahCount = 0;
        quranStruct = REXML::Document.new(File.new('data/Quran/Quran Structure.xml'))
        quranStruct.elements.each('aml/quran/suras/sura') do |surahElem|
            surahNum = surahElem.attributes['num']
            surah = QuranStructSurah.create(
            :surah_num => surahNum,
            :name => surahElem.elements['name'].text,
            :ayah_count => surahElem.attributes['ayahcount'],
            :ruku_count => surahElem.get_elements('rukus/ruku').size,
            :revealed_num => surahElem.elements['revealed'].attributes['num'],
            :revealed_city => surahElem.elements['revealed'].attributes['city']);

            surahElem.elements.each('rukus/ruku') do |rukuElem|
                ruku = surah.rukus.create(
                :surah_num => surahNum,
                :ruku_num => rukuElem.attributes['num'],
                :start_ayah_num => rukuElem.attributes['startayah'],
                :end_ayah_num => rukuElem.attributes['endayah']);
            end

            surahCount += 1
        end
        puts "Imported #{surahCount} Surah definitions.\n"

        sajdaCount = 0
        quranStruct.elements.each('aml/quran/sajdatilawa/sajda') do |sajdaElem|
            sajda = QuranStructSajdaTilawa.create(
            :surah_num => sajdaElem.attributes['sura'],
            :ayah_num => sajdaElem.attributes['ayah']);

            sajdaCount += 1
        end
        puts "Imported #{sajdaCount} Sajda Tilawa definitions.\n"

        juzCount = 0
        quranStruct.elements.each('aml/quran/ajza/juz') do |juzElem|
            juz = QuranStructJuz.create(
            :surah_num => juzElem.attributes['sura'],
            :ayah_num => juzElem.attributes['ayah']);

            juzCount += 1
        end
        puts "Imported #{juzCount} Juz definitions.\n"
    end
end
