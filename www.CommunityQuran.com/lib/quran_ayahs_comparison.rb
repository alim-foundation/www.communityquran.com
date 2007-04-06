class QuranAyahsComparison
    attr_reader :qurans_with_ayahs
    attr_reader :surah_num
    attr_reader :ayah_num
    attr_reader :ayahs
    attr_reader :have_elaborations

    def initialize(qurans, surahNum, ayahNum)
        @qurans_with_ayahs = qurans
        @surah_num = surahNum
        @ayah_num = ayahNum
        @ayahs = qurans.collect { |quran| quran.ayahs.find_by_surah_num_and_ayah_num(surahNum, ayahNum) }
    end

    def theme
        quran = Quran.find_by_contains_ayah_themes(true)
        quran.surahs.find_by_surah_num(@surah_num).themes.find(:first, :conditions => ["start_ayah_num >= ? and ? <= end_ayah_num", @ayah_num, @ayah_num])
    end
end