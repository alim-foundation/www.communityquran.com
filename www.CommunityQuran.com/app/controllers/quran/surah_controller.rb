class Quran::SurahController < QuranController
    QURANS_WITH_SURAH_ELABORATIONS = Quran.find_all_by_contains_surah_elaborations(true)
    QURANS_WITH_SURAH_ELABORATIONS_CODES = QURANS_WITH_SURAH_ELABORATIONS.collect { |quran| quran.code }

    def index
        redirect_to :action => 'elaborate_surah_num', :quran_code => QURANS_WITH_SURAH_ELABORATIONS_CODES[0], :surah_num => 1
    end

    def redirect_elaborate_surah_num
        redirect_to :action => 'elaborate_surah_num', :quran_code => QURANS_WITH_SURAH_ELABORATIONS_CODES[0], :surah_num => params[:surah_num]
    end

    def elaborate_surah_num
        @quran = Quran.find_by_code(params[:quran_code])
        if ! @quran || ! @quran.contains_surah_elaborations
            redirect_to :action => 'elaborate_surah_num', :quran_code => QURANS_WITH_SURAH_ELABORATIONS_CODES[0], :surah_num => params[:surah_num]
            return            
        end

        @surah = @quran.surahs.find_by_surah_num(params[:surah_num])
        @panel = Panel.new
        for other in QURANS_WITH_SURAH_ELABORATIONS
            @panel.add_tab(other.full_name, other.code == @quran.code ? true : false,
                           url_for(:action => 'elaborate_surah_num', :quran_code => other.code, :surah_num => @surah.surah_num))
        end
        
        self.heading = "#{@quran.short_name} Introductory Overview of Surah #{params[:surah_num]}, #{QuranHelper::QURAN_STRUCT.get_surah(@surah.surah_num).name}"
    end

end
