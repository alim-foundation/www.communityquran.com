namespace :aml do
    desc "Import Alim Markup Language (AML) data files"
    task :import => :environment do
        AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Yusuf Ali Translation.xml'))
        AlimMarkup.import_quran_page_images_data_from_aml(File.new('data/Quran/Arabic Quran Pages.xml'))
        malik = AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Malik Translation.xml'))
        AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Malik Themes.xml'), malik)
        AlimMarkup.import_quran_sura_intros_from_aml(File.new('data/Quran/Malik Sura Introductions.xml'), malik)
        AlimMarkup.import_quran_sura_intros_from_aml(File.new('data/Quran/Maududi Sura Introductions.xml'))
        AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Asad Translation.xml'))
        AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Pickthall Translation.xml'))
        AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Roman Transliteration.xml'))
        AlimMarkup.import_quran_subject_index_from_aml(File.new('data/Quran/Subjects Index.xml'))
    end
end