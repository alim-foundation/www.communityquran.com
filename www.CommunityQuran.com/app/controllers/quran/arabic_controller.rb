class Quran::ArabicController < QuranController
    @arabic_quran = nil

    def arabic_quran
        @arabic_quran ||= Quran.find_by_contains_page_images(true)
        return @arabic_quran
    end

    def quran_transliteration
        @quran_transliteration ||= Quran.find_by_code('TLT')
        return @quran_transliteration
    end

    def index
        redirect_to :action => 'page', :page_num => 1
    end

    def page
        @page = arabic_quran.pages.find_by_page_num(params[:page_num])
        if ! @page
            redirect_to :action => 'page', :page_num => 1            
        end

        @image_info = arabic_quran.page_images_info
        @image_map_data = @page.create_image_map_data
        @transliterated_ayahs = @page.create_image_map_data.collect { |data|
            quran_transliteration.ayahs.find_by_surah_num_and_ayah_num(data.surah_num, data.ayah_num)
        }

        # set these in case they're needed by things like surah navigator
        params[:surah_num] = @page.start_surah_num
        params[:ayah_num] = @page.start_ayah_num

        self.heading = @page.ayah_coverage_text(quran_struct)

        self.page_navigation = Sparx::Navigate::Tree.new("page") do |p|
            p.add_path "previous-page", :label => "Previous Page", :url => url_for(:page_num => @image_info.previous_page_num(@page))
            p.add_path "next-page", :label => "Next Page", :url => url_for(:page_num => @image_info.next_page_num(@page))
            add_surah_paths(p, "ayah", true, 1)
            add_surah_ayah_paths(p, "ayah", false)
        end
    end

    def ayah
        surahAyah = SurahAyah.new(:surah_num => active_surah_num, :ayah_num => active_ayah_num)
        ayahPage = QuranPageAyah.find_by_surah_num_and_ayah_num(surahAyah.surah_num, surahAyah.ayah_num)
        redirect_to :action => 'page', :page_num => ayahPage.page_num
    end
end
