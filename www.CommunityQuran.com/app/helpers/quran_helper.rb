module QuranHelper
    def surahs
        return QuranStructSurah.find(:all) 
    end

    def get_surah_elaborations_panel
        panel = Panel.new
        for quran in Quran.find_all_by_contains_surah_elaborations(true)
            panel.add_tab(quran.full_name, quran.code == params[:quran_code] ? true : false,
                          "../#{quran.code}/#{params[:surah_num]}")
        end
        return panel
    end
end
