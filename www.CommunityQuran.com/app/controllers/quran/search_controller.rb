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
        @more_ayahs_available = @ayahs.total_hits > 0 && @ayahs.length < @ayahs.total_hits
        @more_ayahs_url = @more_ayahs_available ? url_for(:action => "search_ayahs", :q => @query) : nil

        @subjects = QuranSubject.find_by_contents(@query)
        @more_subjects_available = @subjects.total_hits > 0 && @subjects.length < @subjects.total_hits
        @more_subjects_url = @more_subjects_available ? url_for(:action => "search_subjects", :q => @query) : nil

        @ayah_elaborations = QuranAyahElaboration.find_by_contents(@query)
        @more_ayah_elaborations_available = @ayah_elaborations.total_hits > 0 && @ayah_elaborations.length < @ayah_elaborations.total_hits
        @more_ayah_elaborations_url = @more_ayah_elaborations_available ? url_for(:action => "search_ayah_elaborations", :q => @query) : nil

        @ayah_themes = QuranAyahsTheme.find_by_contents(@query)
        @more_ayah_themes_available = @ayah_themes.total_hits > 0 && @ayah_themes.length < @ayah_themes.total_hits
        @more_ayah_themes_url = @more_ayah_themes_available ? url_for(:action => "search_ayah_themes", :q => @query) : nil

        total_hits, @surah_elaboration_results = QuranSurah.full_text_search_by_storage(@query)
        @more_surah_elaborations_available = total_hits > 0 && @surah_elaboration_results.length < total_hits
        @more_surah_elaborations_url = @more_surah_elaborations_available ? url_for(:action => "search_surah_elaborations", :q => @query) : nil
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

        @total_hits, @surah_elaboration_results = QuranSurah.full_text_search_by_storage(@query, :page => (params[:page]||1))
        @pages = pages_for(@total_hits)
    end

end
