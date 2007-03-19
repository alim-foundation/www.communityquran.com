class Quran::SearchController < QuranController

    def index
    end

    def pages_for(size, options = {})
        default_options = {:per_page => 10}
        options = default_options.merge options
        pages = Paginator.new self, size, options[:per_page], (params[:page]||1)
        return pages
    end

    def search
        @query = params[:q]
        self.title = "'#{@query}' search results"

        @ayahs = QuranAyah.find_by_contents(@query)
        @more_ayahs_available = @ayahs.length < @ayahs.total_hits
        @more_ayahs_url = @more_ayahs_available ? url_for(:action => "search_ayahs", :q => @query) : ""

        @subjects = QuranSubject.find_by_contents(@query)
        @more_subjects_available = @ayahs.length < @ayahs.total_hits
        @more_subjects_url = @more_subjects_available ? url_for(:action => "search_subjects", :q => @query) : ""

        @ayah_elaborations = QuranAyahElaboration.find_by_contents(@query)
        @more_ayah_elaborations_available = @ayah_elaborations.length < @ayah_elaborations.total_hits
        @more_ayah_elaborations_url = @more_ayah_elaborations_available ? url_for(:action => "search_ayah_elaborations", :q => @query) : ""

        @ayah_themes = QuranAyahsTheme.find_by_contents(@query)
        @more_ayah_themes_available = @ayah_themes.length < @ayah_themes.total_hits
        @more_ayah_themes_url = @more_ayah_themes_available ? url_for(:action => "search_ayah_themes", :q => @query) : ""

        @surah_elaborations = QuranSurah.find_by_contents(@query)
        @more_surah_elaborations_available = @surah_elaborations.length < @surah_elaborations.total_hits
        @more_surah_elaborations_url = @more_surah_elaborations_available ? url_for(:action => "search_surah_elaborations", :q => @query) : ""
    end

    def search_ayahs
        @query = params[:q]
        self.title = "'#{@query}' search results in Qur'an Ayahs"

        @total, @ayahs = QuranAyah.full_text_search(@query, :page => (params[:page]||1))
        @pages = pages_for(@total)
    end

    def search_subjects
        @query = params[:q]
        self.title = "'#{@query}' search results in Qur'an Subjects"

        @total, @subjects = QuranSubject.full_text_search(@query, :page => (params[:page]||1))
        @pages = pages_for(@total)
    end

    def search_ayah_elaborations
        @query = params[:q]
        self.title = "'#{@query}' search results in Qur'an Ayah Elaborations"

        @total, @ayah_elaborations = QuranAyahElaboration.full_text_search(@query, :page => (params[:page]||1))
        @pages = pages_for(@total)
    end

    def search_ayah_themes
        @query = params[:q]
        self.title = "'#{@query}' search results in Qur'an Ayah Themes"

        @total, @ayah_themes = QuranAyahsTheme.full_text_search(@query, :page => (params[:page]||1))
        @pages = pages_for(@total)
    end

    def search_surah_elaborations
        @query = params[:q]
        self.title = "'#{@query}' search results in Qur'an Surah Elaborations"

        @total, @surah_elaborations = QuranAyahsTheme.full_text_search(@query, :page => (params[:page]||1))
        @pages = pages_for(@total)
    end
end
