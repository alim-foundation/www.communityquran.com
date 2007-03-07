class QuranAyahsComparison
    attr_reader :qurans_with_ayahs
    attr_reader :surah_num
    attr_reader :ayah_num
    attr_reader :ayahs

    def initialize(qurans, surahNum, ayahNum)
        @qurans_with_ayahs = qurans
        @surah_num = surahNum
        @ayah_num = ayahNum
        @ayahs = qurans.collect { |quran| quran.ayahs.find_by_surah_num_and_ayah_num(surahNum, ayahNum) }
    end
end