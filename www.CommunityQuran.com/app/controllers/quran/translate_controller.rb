class Quran::TranslateController < QuranController
    @qurans_with_ayah_text = nil

    def compare
        redirect_to :action => 'compare_surah_ayah', :surah_num => 1, :ayah_num => 1
    end

    def qurans_with_ayah_text
        @qurans_with_ayah_text ||= Quran.find_all_by_contains_ayahs(true)
    end

    def default_translation_quran_code
        return "MAL"
    end

    def redirect_compare_surah
        redirect_to :action => 'compare_surah_ayah', :ayah_num => 1
    end

    def compare_surah_ayah
        self.heading = "Translations of Surah #{active_surah_num}, #{active_surah_struct.name} Ayah #{active_ayah_num}"
        @qac = QuranAyahsComparison.new(qurans_with_ayah_text, active_surah_num, active_ayah_num)
        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "redirect_compare_surah")
            add_surah_ayah_paths(p, "compare_surah_ayah")
        end
    end

    def translate
        redirect_to :action => 'translate_surah_ayah', :quran_code => default_translation_quran_code, :surah_num => 1, :ayah_num => 1
    end

    def redirect_translate_surah
        redirect_to :action => 'translate_surah', :quran_code => default_translation_quran_code
    end

    def redirect_translate_surah_rukuh_no_rukuh_num
        redirect_to :action => 'translate_surah_rukuh', :rukuh_num => 1
    end

    def redirect_translate_surah_rukuh
        redirect_to :action => 'translate_surah_rukuh', :quran_code => default_translation_quran_code
    end

    def redirect_translate_surah_ayah
        redirect_to :action => 'translate_surah_ayah', :quran_code => default_translation_quran_code
    end

    def translate_surah
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran
            redirect_to :action => 'translate_surah', :quran_code => default_translation_quran_code
            return
        end

        @surah = @quran.surahs.find_by_surah_num(active_surah_num)
        self.heading = "#{@quran.short_name} translation of Surah #{quran_struct.get_surah(@surah.surah_num).name}"

        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "translate_surah")
        end        
    end

    def translate_surah_position_ayah
        redirect_to :action => 'translate_surah', :anchor => "S#{active_surah_num}A#{active_ayah_num}"
    end

    def translate_surah_rukuh
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran
            redirect_to :action => 'translate_surah_rukuh', :quran_code => default_translation_quran_code
            return
        end

        surahNum = active_surah_num
        surahStruct = quran_struct.get_surah(surahNum)
        startAyahNum = 1
        endAyahNum = surahStruct.ayah_count
        if surahStruct.rukuh_count > 0
            rukuh = active_rukuh_num ? surahStruct.rukuhs.find_by_rukuh_num(active_rukuh_num) :
                                       surahStruct.rukuhs.find(:first, :conditions => ["start_ayah_num >= ? and ? <= end_ayah_num", active_ayah_num, active_ayah_num])
            if rukuh
                startAyahNum = rukuh.start_ayah_num
                endAyahNum = rukuh.end_ayah_num
                params[:rukuh_num] = rukuh.rukuh_num
                self.heading = "#{@quran.short_name} translation of Surah #{surahStruct.name} Rukuh #{rukuh.rukuh_num} (Ayahs #{rukuh.start_ayah_num} to #{rukuh.end_ayah_num})"
            end
        else
            self.heading = "#{@quran.short_name} translation of Surah #{surahStruct.name}"
        end

        @ayahs = @quran.ayahs.find(:all, :conditions => ["surah_num = ? and ayah_num >= ? and ayah_num <= ?", surahStruct.surah_num, startAyahNum, endAyahNum])

        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "redirect_translate_surah_rukuh_no_rukuh_num")
            add_surah_rukuh_paths(p)
        end
    end

    def redirect_translate_surah_ayah_no_ayah_num
        redirect_to :action => 'translate_surah_ayah', :ayah_num => 1
    end

    def translate_surah_ayah
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran
            redirect_to :action => 'translate_surah_ayah', :quran_code => default_translation_quran_code
            return            
        end

        @ayah = @quran.ayahs.find_by_surah_num_and_ayah_num(active_surah_num, active_ayah_num)
        self.heading = "#{@quran.short_name} translation of Surah #{quran_struct.get_surah(@ayah.surah_num).name} Ayah #{@ayah.ayah_num}"

        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            add_surah_paths(p, "redirect_translate_surah_ayah_no_ayah_num")
            add_surah_ayah_paths(p, "translate_surah_ayah")
            p.add_path 'compare', :label => 'Compare this ayah with other translations', :url => url_for(:controller => 'Quran::Translate', :action => 'compare_surah_ayah', :surah_num => @ayah.surah_num, :ayah_num => @ayah.ayah_num)
            p.add_path 'entire-surah', :label => 'View the entire Surah', :url => url_for(:controller => 'Quran::Translate', :action => 'translate_surah_position_ayah', :surah_num => @ayah.surah_num, :ayah_num => @ayah.ayah_num)
        end
    end

end
