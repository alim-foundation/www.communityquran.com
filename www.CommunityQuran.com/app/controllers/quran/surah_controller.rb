class Quran::SurahController < QuranController
    QURANS_WITH_SURAH_ELABORATIONS = Quran.find_all_by_contains_surah_elaborations(true)
    QURANS_WITH_SURAH_ELABORATIONS_CODES = QURANS_WITH_SURAH_ELABORATIONS.collect { |quran| quran.code }

    def index
        redirect_to :action => 'elaborate_surah_num', :quran_code => QURANS_WITH_SURAH_ELABORATIONS_CODES[0], :surah_num => 1
    end

    def redirect_elaborate_surah_num
        redirect_to :action => 'elaborate_surah_num', :quran_code => QURANS_WITH_SURAH_ELABORATIONS_CODES[0]
    end

    def elaborate_surah_num
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran || ! @quran.contains_surah_elaborations
            redirect_to :action => 'elaborate_surah_num', :quran_code => QURANS_WITH_SURAH_ELABORATIONS_CODES[0]
            return            
        end

        @surah = @quran.surahs.find_by_surah_num(active_surah_num)
        @panel = Panel.new

        self.heading = "#{@quran.short_name} Introductory Overview of Surah #{@surah.surah_num}, #{QURAN_STRUCT.get_surah(@surah.surah_num).name}"
        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "elaborate_surah_num")
            for other in QURANS_WITH_SURAH_ELABORATIONS
                if other.code != @quran.code then
                    p.add_path "compare_#{other.code}", :label => "View in #{other.full_name}",
                               :url => url_for(:action => 'elaborate_surah_num', :quran_code => other.code, :surah_num => @surah.surah_num)
                end
            end
        end        
    end

end
