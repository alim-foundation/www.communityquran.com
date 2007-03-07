module QuranHelper
    SURAH_STRUCTS = QuranStructSurah.find(:all)
    AJZA = QuranStructJuz.find(:all)
    SAJDA_TILAWA = QuranStructSajdaTilawa.find(:all)
    ARABIC_QURAN = Quran.find_by_contains_page_images(true)
    QURANS_WITH_AYAH_TEXT = Quran.find_all_by_contains_ayahs(true)
    QURANS_WITH_SURAH_ELABORATIONS = Quran.find_all_by_contains_surah_elaborations(true)

    def get_active_quran_page
        return ARABIC_QURAN.pages.find_by_page_num(params[:page_num])
    end

    def get_active_quran_ayahs_comparison
        return QuranAyahsComparison.new(QURANS_WITH_AYAH_TEXT, params[:surah_num], params[:ayah_num])
    end

    def get_surah_elaborations_panel
        panel = Panel.new
        for quran in QURANS_WITH_SURAH_ELABORATIONS
            panel.add_tab(quran.full_name, quran.code == params[:quran_code] ? true : false,
                          "../#{quran.code}/#{params[:surah_num]}")
        end
        return panel
    end
end
