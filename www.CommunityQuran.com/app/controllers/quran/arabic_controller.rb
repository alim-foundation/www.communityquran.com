class Quran::ArabicController < QuranController
    ARABIC_QURAN = Quran.find_by_contains_page_images(true)
    QURAN_TRANSLITERATION = Quran.find_by_code('TLT')

    def index
        redirect_to :action => 'page', :page_num => 1
    end

    def page
        @page = ARABIC_QURAN.pages.find_by_page_num(params[:page_num])
        if ! @page
            redirect_to :action => 'page', :page_num => 1            
        end

        @image_info = ARABIC_QURAN.page_images_info
        @image_map_data = @page.create_image_map_data
        @transliterated_ayahs = @page.create_image_map_data.collect { |data|
            QURAN_TRANSLITERATION.ayahs.find_by_surah_num_and_ayah_num(data.surah_num, data.ayah_num)
        }

        # set these in case they're needed by things like surah navigator
        params[:surah_num] = @page.start_surah_num
        params[:ayah_num] = @page.start_ayah_num

        self.heading = @page.ayah_coverage_text
    end

    def ayah
        surahAyah = SurahAyah.new(:surah_num => params[:surah_num], :ayah_num => params[:ayah_num])
        ayahPage = QuranPageAyah.find_by_surah_num_and_ayah_num(surahAyah.surah_num, surahAyah.ayah_num)
        redirect_to :action => 'page', :page_num => ayahPage.page_num
    end
end
