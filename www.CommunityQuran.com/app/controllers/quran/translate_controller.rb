class Quran::TranslateController < QuranController
    DEFAULT_QURAN_TRANSLATION = 'MAL'
    QURANS_WITH_AYAH_TEXT = Quran.find_all_by_contains_ayahs(true)

    def compare
        redirect_to :action => 'compare_surah_ayah', :surah_num => 1, :ayah_num => 1
    end

    def redirect_compare_surah
        redirect_to :action => 'compare_surah_ayah', :surah_num => params[:surah_num], :ayah_num => 1
    end

    def compare_surah_ayah
        self.heading = "Translations of Surah #{params[:surah_num]}, #{QuranHelper::QURAN_STRUCT.get_surah(Integer(params[:surah_num])).name} Ayah #{params[:ayah_num]}"
        @qac = QuranAyahsComparison.new(QURANS_WITH_AYAH_TEXT, params[:surah_num], params[:ayah_num])
    end

    def translate
        redirect_to :action => 'translate_surah_ayah', :quran_code => DEFAULT_QURAN_TRANSLATION, :surah_num => 1, :ayah_num => 1
    end

    def redirect_translate_surah
        redirect_to :action => 'translate_surah', :quran_code => DEFAULT_QURAN_TRANSLATION, :surah_num => params[:surah_num]
    end

    def redirect_translate_surah_rukuh
        redirect_to :action => 'translate_surah_rukuh', :quran_code => DEFAULT_QURAN_TRANSLATION, :surah_num => params[:surah_num], :rukuh_num => params[:rukuh_num]
    end

    def redirect_translate_surah_ayah
        redirect_to :action => 'translate_surah_ayah', :quran_code => DEFAULT_QURAN_TRANSLATION, :surah_num => params[:surah_num], :ayah_num => params[:ayah_num]
    end

    def translate_surah
        @quran = Quran.find_by_code(params[:quran_code])
        if ! @quran
            redirect_to :action => 'translate_surah', :quran_code => DEFAULT_QURAN_TRANSLATION, :surah_num => params[:surah_num]
            return
        end

        @surah = @quran.surahs.find_by_surah_num(params[:surah_num])
        self.heading = "#{@quran.short_name} translation of Surah #{QuranHelper::QURAN_STRUCT.get_surah(@surah.surah_num).name}"
    end

    def translate_surah_position_ayah
        redirect_to :action => 'translate_surah', :quran_code => params[:quran_code],
                                                  :surah_num => params[:surah_num],
                                                  :anchor => "S#{params[:surah_num]}A#{params[:ayah_num]}"
    end

    def translate_surah_rukuh
        @quran = Quran.find_by_code(params[:quran_code])
        if ! @quran
            redirect_to :action => 'translate_surah_rukuh', :quran_code => DEFAULT_QURAN_TRANSLATION, :surah_num => params[:surah_num], :rukuh_num => params[:rukuh_num]
            return
        end

        surahNum = Integer(params[:surah_num])
        surahStruct = QuranHelper::QURAN_STRUCT.get_surah(surahNum)
        startAyahNum = 1
        endAyahNum = surahStruct.ayah_count
        if surahStruct.rukuh_count > 0
            rukuh = params[:rukuh_num] ? surahStruct.rukuhs.find_by_rukuh_num(params[:rukuh_num]) :
                                         surahStruct.rukuhs.find(:first, :conditions => ["start_ayah_num >= ? and ? <= end_ayah_num", Integer(params[:ayah_num]), Integer(params[:ayah_num])])
            if rukuh
                startAyahNum = rukuh.start_ayah_num
                endAyahNum = rukuh.end_ayah_num
                params[:rukuh_num] = rukuh.rukuh_num
                self.heading = "#{@quran.short_name} translation of Surah #{surahStruct.name} Rukuh #{rukuh.rukuh_num}"
            end
        else
            self.heading = "#{@quran.short_name} translation of Surah #{surahStruct.name}"
        end

        @ayahs = @quran.ayahs.find(:all, :conditions => ["surah_num = ? and ayah_num >= ? and ayah_num <= ?", surahStruct.surah_num, startAyahNum, endAyahNum])
    end

    def translate_surah_ayah
        @quran = Quran.find_by_code(params[:quran_code])
        if ! @quran
            redirect_to :action => 'translate_surah_ayah', :quran_code => DEFAULT_QURAN_TRANSLATION, :surah_num => params[:surah_num], :ayah_num => params[:ayah_num]
            return            
        end

        @ayah = @quran.ayahs.find_by_surah_num_and_ayah_num(params[:surah_num], params[:ayah_num])
        self.heading = "#{@quran.short_name} translation of Surah #{QuranHelper::QURAN_STRUCT.get_surah(@ayah.surah_num).name} Ayah #{@ayah.ayah_num}"
    end

end
