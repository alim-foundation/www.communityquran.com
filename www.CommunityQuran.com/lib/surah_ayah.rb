class SurahAyah
    attr_accessor :surah_num
    attr_accessor :ayah_num

    def initialize(options)
        if options[:id]
            items = options[:id].split('.')
            @surah_num = Integer(items[0])
            @ayah_num = Integer(items[1])
        else
            @surah_num = Integer(options[:surah_num] || 1)
            @ayah_num = Integer(options[:ayah_num] || 1)
        end
    end

    def id
        return "#{self.surah_num}.#{self.ayah_num}"
    end
end
