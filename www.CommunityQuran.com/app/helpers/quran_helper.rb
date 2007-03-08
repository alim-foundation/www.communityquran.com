module QuranHelper
    QURAN_STRUCT = QuranStruct.find(:first)
    ARABIC_QURAN = Quran.find_by_contains_page_images(true)
    QURANS_WITH_AYAH_TEXT = Quran.find_all_by_contains_ayahs(true)
    QURANS_WITH_SURAH_ELABORATIONS = Quran.find_all_by_contains_surah_elaborations(true)

    def get_active_surah_num
        return Integer(params[:surah_num])
    end

    def get_active_ayah_num
        return Integer(params[:ayah_num])
    end

    def get_active_rukuh_num
        return Integer(params[:rukuh_num])
    end

    def get_active_surah_struct
        return QURAN_STRUCT.get_surah(get_active_surah_num)
    end

    def get_previous_ayah_url(action)
        surahNum = Integer(params[:surah_num])
        ayahNum = Integer(params[:ayah_num])
        if ayahNum > 1
            ayahNum -= 1
        else
            if surahNum > 1
                surahNum -= 1
            else
                surahNum = QURAN_STRUCT.surah_count
            end
            ayahNum =QURAN_STRUCT.get_surah(surahNum).ayah_count
        end
        url_for :action => action, :surah_num => surahNum, :ayah_num => ayahNum
    end

    def get_next_ayah_url(action)
        surahNum = Integer(params[:surah_num])
        ayahNum = Integer(params[:ayah_num])
        if ayahNum < QURAN_STRUCT.get_surah(surahNum).ayah_count
            ayahNum += 1
        else
            if surahNum < QURAN_STRUCT.surah_count
                surahNum += 1
            else
                surahNum = 1
            end
            ayahNum = 1
        end
        url_for :action => action, :surah_num => surahNum, :ayah_num => ayahNum 
    end

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
