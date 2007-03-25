module Quran::SearchHelper
    COLLECTION_ACTIONS =
    [
       ['All', 'search'],
       [QuranAyah.ferret_index_collection_name, 'search_ayahs'],
       [QuranSubject.ferret_index_collection_name, 'search_subjects'],
       [QuranAyahElaboration.ferret_index_collection_name, 'search_ayah_elaborations'],
       [QuranAyahsTheme.ferret_index_collection_name, 'search_ayah_themes'],
       [QuranSurah.ferret_index_collection_name, 'search_surah_elaborations']
    ]

    COLLECTION_NAMES_FOR_ACTION = {}
    COLLECTION_ACTIONS.each do |item|
        COLLECTION_NAMES_FOR_ACTION[item[1]] = item[0]
    end

    RESULTS_PER_PAGE_OPTIONS = [10, 25, 50, 75, 100]

    def collection_name
        COLLECTION_NAMES_FOR_ACTION[controller.action_name]
    end

    def results_per_page_options  
        return RESULTS_PER_PAGE_OPTIONS
    end

    def collection_actions
        COLLECTION_ACTIONS.reject { |item| item[1] == controller.action_name }
    end
end