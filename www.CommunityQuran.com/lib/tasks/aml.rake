namespace :aml do
    desc "Import Alim Markup Language (AML) data files"
    task :import => :environment do
        AlimMarkup.import_quran_page_images_data_from_aml(File.new('data/Quran/Arabic Quran Pages Sample.xml'))
        yat = AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Yusuf Ali Translation Sample.xml'))
        AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Malik Themes Sample.xml'), yat)
        AlimMarkup.import_quran_text_from_aml(File.new('data/Quran/Malik Themes Sample.xml'))
        AlimMarkup.import_quran_sura_intros_from_aml(File.new('data/Quran/Malik Sura Introductions Sample.xml'), yat)
        AlimMarkup.import_quran_sura_intros_from_aml(File.new('data/Quran/Malik Sura Introductions Sample.xml'))
        AlimMarkup.import_quran_subject_index_from_aml(File.new('data/Quran/Subjects Index Sample.xml'))
    end
end