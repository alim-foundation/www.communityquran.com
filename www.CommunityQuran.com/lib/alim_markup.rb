module AlimMarkup

    def self.import_quran_page_images_data_from_aml(source)
        doc = REXML::Document.new(source)
        catalogElem = doc.elements['aml/quran/catalog']
        namesElem = catalogElem.elements['names']
        contentElem = catalogElem.elements['content']

        code = catalogElem.attributes['id']
        existing = Quran.find_by_code(code)
        if existing
            existing.destroy
            puts "** Deleted existing #{code}."
        end

        quran = Quran.create(:code => code,
                             :short_name => namesElem.attributes['short'],
                             :full_name => namesElem.attributes['full'],
                             :contains_page_images => true)

        puts "Importing #{quran.full_name} (#{quran.code}, #{quran.short_name}) from #{source.to_s}.\n"

        lastPageNum = nil
        page = quran.pages.create!(:page_num => 1, :start_surah_num => 0, :start_ayah_num => 0, :end_surah_num => 0, :end_ayah_num => 0)
        doc.elements.each("aml/quran/sura") do |surahElem|
            surah_num = surahElem.attributes['num']

            surah = quran.surahs.create(:surah_num => surah_num)

            surahElem.elements.each('ayah') do |ayahElem|
                pageNum = Integer(ayahElem.attributes['page'])
                if page.page_num != pageNum
                    page = quran.pages.create!(:page_num => pageNum, :start_surah_num => 0, :start_ayah_num => 0, :end_surah_num => 0, :end_ayah_num => 0)     
                end

                page.ayahs.create!(:quran_id => quran.id,    # denormalized for performance
                                   :surah_num => surah_num,
                                   :ayah_num => ayahElem.attributes['num'],
                                   :page_num => ayahElem.attributes['page'],
                                   :x_start => ayahElem.attributes['xstart'],
                                   :x_end => ayahElem.attributes['xend'],
                                   :y_start => ayahElem.attributes['ystart'],
                                   :y_end => ayahElem.attributes['yend'])

                lastPageNum = pageNum
            end

            puts "  Imported #{quran.short_name} Surah #{surah_num}.\n"
        end

        for page in quran.pages.find(:all)
            collection = page.ayahs.find(:all)
            page.start_surah_num = collection.first.surah_num
            page.start_ayah_num = collection.first.ayah_num
            page.end_surah_num = collection.last.surah_num
            page.end_ayah_num = collection.last.ayah_num
            page.save!
        end

        quran.create_page_images_info(:page_count => lastPageNum,
                                      :page_image_name_format => contentElem.attributes['imgfmt'],
                                      :image_width => contentElem.attributes['imgwidth'],
                                      :line_height => contentElem.attributes['lineheight'],
                                      :min_line_height => contentElem.attributes['minlineheight'])

        puts "  Done importing #{quran.short_name}.\n"
    end

    def self.import_quran_sura_intros_from_aml(source, mergeWithQuran = nil)
        doc = REXML::Document.new(source)
        catalogElem = doc.elements['aml/surainfo/catalog']
        namesElem = catalogElem.elements['names'];

        unless mergeWithQuran
            code = catalogElem.attributes['id']
            existing = Quran.find_by_code(code)
            if existing
                existing.destroy
                puts "** Deleted existing #{code}."
            end
        end

        quran = mergeWithQuran ||
                Quran.create!(:code => code,
                              :short_name => namesElem.attributes['short'],
                              :full_name => namesElem.attributes['full'])

        quran.contains_surah_elaborations = true

        puts "#{mergeWithQuran ? 'Merging' : 'Importing'} Surah Introductions into #{quran.full_name} (#{quran.code}, #{quran.short_name}) from #{source.to_s}.\n"

        doc.elements.each("aml/surainfo/sura") do |surahElem|
            surah_num = surahElem.attributes['num']

            # switch <section> tags to be <div class='section'><div class='heading'>heading
            surahElem.elements.each('section') do |e|
                e.name = 'div'
                e.add_attribute("class", "section")
                heading = e.attributes["heading"]
                e.delete_attribute("heading")
                h1 = REXML::Element.new 'div'
                h1.add_attribute('class', 'heading')
                h1.add_text heading
                e.insert_before(e[0], h1)
            end

            surah = quran.surahs.find_or_create_by_surah_num(surah_num)
            surah.overview = surahElem.children.to_s
            surah.save!

            puts "  Imported #{quran.short_name} Surah #{surah_num}.\n"
        end

        quran.save! # in case we updated anything while saving children (like contains_* columns)
        puts "  Done importing #{quran.short_name}.\n"
    end

    def self.import_quran_text_from_aml(source, mergeWithQuran = nil)
        doc = REXML::Document.new(source)
        catalogElem = doc.elements['aml/quran/catalog']
        namesElem = catalogElem.elements['names'];

        unless mergeWithQuran
            code = catalogElem.attributes['id']
            existing = Quran.find_by_code(code)
            if existing
                existing.destroy
                puts "** Deleted existing #{code}."
            end
        end

        quran = mergeWithQuran ||
                Quran.create!(:code => code,
                              :short_name => namesElem.attributes['short'],
                              :full_name => namesElem.attributes['full'])

        puts "#{mergeWithQuran ? 'Merging' : 'Importing'} #{quran.full_name} (#{quran.code}, #{quran.short_name}) from #{source.to_s}.\n"

        doc.elements.each("aml/quran/sura") do |surahElem|
            surah_num = surahElem.attributes['num']

            surah = quran.surahs.find_or_create_by_surah_num(surah_num)
            surahElem.elements.each('theme') do |themeElem|
                surah.themes.create!(:start_ayah_num => themeElem.attributes['startAyah'] || themeElem.attributes['ayah'],
                                     :end_ayah_num => themeElem.attributes['endAyah'] || themeElem.attributes['ayah'],
                                     :theme => themeElem.children.to_s)
                quran.contains_ayah_themes = true
            end

            surahElem.elements.each('ayah') do |ayahElem|
                ayah_num = ayahElem.attributes['num']

                # copy all the elaboration elements into an array so that we can remove them safely
                # since we want to grab the ayah element's text and all tags without grabbing notes
                elaborationElems = {}
                ayahElem.elements.each('note') do |noteElem|
                    elaborationElems[noteElem.attributes['id']] = noteElem.children.to_s
                end
                ayahElem.elements.delete_all('note')

                ayahElem.elements.each('index') do |indexElem|
                    quran.add_subject_location(indexElem.attributes['topic'], indexElem.attributes['subtopic'],
                                               surah_num, ayah_num)
                    quran.contains_subjects = true
                end
                ayahElem.elements.delete_all('index')

                # switch <fn> tags to be <span class='fn'>
                ayahElem.elements.each('fn') do |e|
                    e.name = 'span'
                    e.add_attribute("class", "fn")
                end

                # create the ayah and include quran_id and surah_num (denormalized) for app query performance 
                ayah = surah.ayahs.create!(:quran_id => quran.id, :surah_num => surah_num,
                                           :ayah_num => ayah_num, :text => ayahElem.children.to_s)

                # now store the notes separately
                elaborationElems.keys.each do |noteId|
                    ayah.elaborations.create!(:code => noteId, :text => elaborationElems[noteId])
                    quran.contains_ayah_elaborations = true
                end

                quran.contains_ayahs = true
            end

            puts "  Imported #{quran.short_name} Surah #{surah_num}.\n"
        end

        quran.save! # in case we updated anything while saving children (like contains_* columns)
        puts "  Done importing #{quran.short_name}.\n"

        return quran
    end

    def self.import_quran_subject_index_from_aml(source)
        doc = REXML::Document.new(source)
        catalogElem = doc.elements['aml/index/catalog']
        namesElem = catalogElem.elements['names'];

        code = catalogElem.attributes['id']
        existing = Quran.find_by_code(code)
        if existing
            existing.destroy
            puts "** Deleted existing #{code}."
        end

        quran = Quran.create!(:code => catalogElem.attributes['id'],
                              :short_name => namesElem.attributes['short'],
                              :full_name => namesElem.attributes['full'],
                              :contains_subjects => true)

        puts "Importing #{quran.full_name} (#{quran.code}, #{quran.short_name}) from #{source.to_s}.\n"

        doc.elements.each("aml/index/topic") do |topicElem|
            topic = topicElem.attributes['name']

            topicElem.elements.each('ayah') do |ayahElem|
                ayahInfo = ayahElem.attributes["id"].split(".")
                quran.add_subject_location(topic, nil, ayahInfo[0], ayahInfo[1])
            end

            topicElem.elements.each('subtopic') do |subtopicElem|
                subtopic = subtopicElem.attributes['name']

                subtopicElem.elements.each('ayah') do |ayahElem|
                    ayahInfo = ayahElem.attributes["id"].split(".")
                    quran.add_subject_location(topic, subtopic, ayahInfo[0], ayahInfo[1])
                end
            end

            puts "  Imported #{quran.short_name} topic #{topic}.\n"
        end
        puts "  Done importing #{quran.short_name}.\n"
    end
end