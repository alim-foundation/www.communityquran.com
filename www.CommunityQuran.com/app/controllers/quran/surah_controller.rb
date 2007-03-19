class Quran::SurahController < QuranController
    @qurans_with_surah_elaborations = nil
      
    def qurans_with_surah_elaborations
        @qurans_with_surah_elaborations ||= Quran.find_all_by_contains_surah_elaborations(true)
    end

    def default_surah_elaborations_quran_code
        return "MAL"
    end

    def index
        redirect_to :action => 'elaborate_surah_num', :quran_code => default_surah_elaborations_quran_code, :surah_num => 1
    end

    def redirect_elaborate_surah_num
        redirect_to :action => 'elaborate_surah_num', :quran_code => default_surah_elaborations_quran_code
    end

    def elaborate_surah_num
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran || ! @quran.contains_surah_elaborations
            redirect_to :action => 'elaborate_surah_num', :quran_code => default_surah_elaborations_quran_code
            return            
        end

        @surah = @quran.surahs.find_by_surah_num(active_surah_num)
        @panel = Panel.new

        self.heading = "#{@quran.short_name} Introductory Overview of Surah #{@surah.surah_num}, #{quran_struct.get_surah(@surah.surah_num).name}"
        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "elaborate_surah_num", true, nil, true)
            for other in qurans_with_surah_elaborations
                if other.code != @quran.code then
                    p.add_path "compare_#{other.code}", :label => "View in #{other.full_name}",
                               :url => url_for(:action => 'elaborate_surah_num', :quran_code => other.code, :surah_num => @surah.surah_num)
                end
            end
        end        
    end

end
