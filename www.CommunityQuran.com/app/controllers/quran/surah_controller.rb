class Quran::SurahController < QuranController
    @qurans_with_surah_elaborations = nil
      
    def qurans_with_surah_elaborations
        @qurans_with_surah_elaborations ||= Quran.find_all_by_contains_surah_elaborations(true)
    end

    def default_surah_elaborations_quran_code
        return "MAL"
    end

    def default_ayah_themes_quran_code
        return "MAL"
    end

    def index
        redirect_to :action => 'elaborate_surah', :quran_code => default_surah_elaborations_quran_code, :surah_num => 1
    end

    def redirect_elaborate_surah
        redirect_to :action => 'elaborate_surah', :quran_code => default_surah_elaborations_quran_code
    end

    def redirect_ayah_themes
        redirect_to :action => 'ayah_themes', :quran_code => default_ayah_themes_quran_code
    end

    def elaborate_surah
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran || ! @quran.contains_surah_elaborations
            redirect_to :action => 'elaborate_surah', :quran_code => default_surah_elaborations_quran_code
            return            
        end

        @surah = @quran.surahs.find_by_surah_num(active_surah_num)

        self.heading = "#{@quran.short_name} Introductory Overview of Surah #{@surah.surah_num}, #{quran_struct.get_surah(@surah.surah_num).name}"
        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "elaborate_surah", true, nil, true)
            for other in qurans_with_surah_elaborations
                if other.code != @quran.code then
                    p.add_path "compare_#{other.code}", :label => "View in #{other.full_name}",
                               :url => url_for(:action => 'elaborate_surah', :quran_code => other.code, :surah_num => @surah.surah_num)
                end
            end
            p.add_path "theme_#{other.code}", :label => "View Ayah Themes from #{other.full_name}",
                       :url => url_for(:action => 'ayah_themes', :quran_code => default_ayah_themes_quran_code, :surah_num => @surah.surah_num)
        end
    end

    def ayah_themes
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran || ! @quran.contains_ayah_themes
            redirect_to :action => 'ayah_themes', :quran_code => default_surah_themes_quran_code
            return
        end

        @surah = @quran.surahs.find_by_surah_num(active_surah_num)
        @themes = @surah.themes
        
        self.heading = "#{@quran.short_name} Themes in Surah #{@surah.surah_num}, #{quran_struct.get_surah(@surah.surah_num).name}"
        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "ayah_themes", true, nil, true)
            for other in qurans_with_surah_elaborations
                p.add_path "compare_#{other.code}", :label => "View in #{other.full_name}",
                           :url => url_for(:action => 'elaborate_surah', :quran_code => other.code, :surah_num => @surah.surah_num)
            end
        end        
    end
end
