# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 5) do

  create_table "quran", :force => true do |t|
    t.column "code",                        :string,   :limit => 16,                :null => false
    t.column "short_name",                  :string,                                :null => false
    t.column "full_name",                   :string,                                :null => false
    t.column "author",                      :string
    t.column "description",                 :text
    t.column "contains_surah_elaborations", :boolean
    t.column "contains_ayahs",              :boolean
    t.column "contains_ayah_elaborations",  :boolean
    t.column "contains_ayah_themes",        :boolean
    t.column "contains_subjects",           :boolean
    t.column "created_at",                  :datetime,                              :null => false
    t.column "updated_at",                  :datetime,                              :null => false
    t.column "lock_version",                :integer,                :default => 0, :null => false
  end

  add_index "quran", ["code"], :name => "unique_quran_code", :unique => true
  add_index "quran", ["short_name"], :name => "unique_quran_short_name", :unique => true
  add_index "quran", ["full_name"], :name => "unique_quran_full_name", :unique => true

  create_table "quran_ayah", :force => true do |t|
    t.column "quran_surah_id", :integer,                 :null => false
    t.column "ayah_num",       :integer,                 :null => false
    t.column "text",           :text,                    :null => false
    t.column "created_at",     :datetime,                :null => false
    t.column "updated_at",     :datetime,                :null => false
    t.column "lock_version",   :integer,  :default => 0, :null => false
  end

  add_index "quran_ayah", ["quran_surah_id"], :name => "quran_surah_id"

  create_table "quran_ayah_elaboration", :force => true do |t|
    t.column "quran_ayah_id", :integer,                 :null => false
    t.column "num",           :integer
    t.column "code",          :string
    t.column "text",          :text,                    :null => false
    t.column "created_at",    :datetime,                :null => false
    t.column "updated_at",    :datetime,                :null => false
    t.column "lock_version",  :integer,  :default => 0, :null => false
  end

  add_index "quran_ayah_elaboration", ["quran_ayah_id"], :name => "quran_ayah_id"

  create_table "quran_ayahs_theme", :force => true do |t|
    t.column "quran_surah_id", :integer,                 :null => false
    t.column "start_ayah_num", :integer,                 :null => false
    t.column "end_ayah_num",   :integer,                 :null => false
    t.column "theme",          :text,                    :null => false
    t.column "created_at",     :datetime,                :null => false
    t.column "updated_at",     :datetime,                :null => false
    t.column "lock_version",   :integer,  :default => 0, :null => false
  end

  add_index "quran_ayahs_theme", ["quran_surah_id"], :name => "quran_surah_id"

  create_table "quran_page_image", :force => true do |t|
    t.column "surah_num",    :integer,                 :null => false
    t.column "ayah_num",     :integer,                 :null => false
    t.column "page_num",     :integer,                 :null => false
    t.column "xstart",       :integer,                 :null => false
    t.column "xend",         :integer,                 :null => false
    t.column "ystart",       :integer,                 :null => false
    t.column "yend",         :integer,                 :null => false
    t.column "created_at",   :datetime,                :null => false
    t.column "updated_at",   :datetime,                :null => false
    t.column "lock_version", :integer,  :default => 0, :null => false
  end

  add_index "quran_page_image", ["surah_num"], :name => "surah_num"

  create_table "quran_struct_juz", :id => false, :force => true do |t|
    t.column "juz_num",      :integer,                 :null => false
    t.column "surah_num",    :integer,                 :null => false
    t.column "ayah_num",     :integer,                 :null => false
    t.column "created_at",   :datetime,                :null => false
    t.column "updated_at",   :datetime,                :null => false
    t.column "lock_version", :integer,  :default => 0, :null => false
  end

  add_index "quran_struct_juz", ["surah_num"], :name => "surah_num"

  create_table "quran_struct_sajda_tilawa", :id => false, :force => true do |t|
    t.column "sajda_num",    :integer,                 :null => false
    t.column "surah_num",    :integer,                 :null => false
    t.column "ayah_num",     :integer,                 :null => false
    t.column "created_at",   :datetime,                :null => false
    t.column "updated_at",   :datetime,                :null => false
    t.column "lock_version", :integer,  :default => 0, :null => false
  end

  add_index "quran_struct_sajda_tilawa", ["surah_num"], :name => "surah_num"

  create_table "quran_struct_surah", :id => false, :force => true do |t|
    t.column "surah_num",     :integer,                 :null => false
    t.column "name",          :string,                  :null => false
    t.column "ayah_count",    :integer,                 :null => false
    t.column "revealed_num",  :integer,                 :null => false
    t.column "revealed_city", :string,                  :null => false
    t.column "created_at",    :datetime,                :null => false
    t.column "updated_at",    :datetime,                :null => false
    t.column "lock_version",  :integer,  :default => 0, :null => false
  end

  create_table "quran_struct_surah_ruku", :force => true do |t|
    t.column "surah_num",      :integer,                 :null => false
    t.column "ruku_num",       :integer,                 :null => false
    t.column "start_ayah_num", :integer,                 :null => false
    t.column "end_ayah_num",   :integer,                 :null => false
    t.column "created_at",     :datetime,                :null => false
    t.column "updated_at",     :datetime,                :null => false
    t.column "lock_version",   :integer,  :default => 0, :null => false
  end

  add_index "quran_struct_surah_ruku", ["surah_num"], :name => "surah_num"

  create_table "quran_subject", :force => true do |t|
    t.column "quran_id",        :integer,                                 :null => false
    t.column "parent_id",       :integer
    t.column "topic",           :string,   :limit => 384,                 :null => false
    t.column "full_topic_path", :string,   :limit => 1024,                :null => false
    t.column "created_at",      :datetime,                                :null => false
    t.column "updated_at",      :datetime,                                :null => false
    t.column "lock_version",    :integer,                  :default => 0, :null => false
  end

  add_index "quran_subject", ["quran_id"], :name => "quran_id"
  add_index "quran_subject", ["parent_id"], :name => "parent_id"

  create_table "quran_subject_location", :force => true do |t|
    t.column "quran_subject_id", :integer
    t.column "surah_num",        :integer,                 :null => false
    t.column "ayah_num",         :integer
    t.column "created_at",       :datetime,                :null => false
    t.column "updated_at",       :datetime,                :null => false
    t.column "lock_version",     :integer,  :default => 0, :null => false
  end

  add_index "quran_subject_location", ["quran_subject_id"], :name => "quran_subject_id"
  add_index "quran_subject_location", ["surah_num"], :name => "surah_num"

  create_table "quran_surah", :force => true do |t|
    t.column "quran_id",     :integer,                 :null => false
    t.column "surah_num",    :integer,                 :null => false
    t.column "overview",     :text
    t.column "created_at",   :datetime,                :null => false
    t.column "updated_at",   :datetime,                :null => false
    t.column "lock_version", :integer,  :default => 0, :null => false
  end

  add_index "quran_surah", ["quran_id"], :name => "quran_id"
  add_index "quran_surah", ["surah_num"], :name => "surah_num"

  create_table "system_setting", :force => true do |t|
    t.column "name",         :string,                  :null => false
    t.column "value",        :text,                    :null => false
    t.column "created_at",   :datetime,                :null => false
    t.column "updated_at",   :datetime,                :null => false
    t.column "lock_version", :integer,  :default => 0, :null => false
  end

  add_index "system_setting", ["name"], :name => "index_system_setting_on_name", :unique => true

  add_foreign_key "quran_ayah", ["quran_surah_id"], "quran_surah", ["id"], :name => "quran_ayah_ibfk_1"

  add_foreign_key "quran_ayah_elaboration", ["quran_ayah_id"], "quran_ayah", ["id"], :name => "quran_ayah_elaboration_ibfk_1"

  add_foreign_key "quran_ayahs_theme", ["quran_surah_id"], "quran_surah", ["id"], :name => "quran_ayahs_theme_ibfk_1"

  add_foreign_key "quran_page_image", ["surah_num"], "quran_struct_surah", ["surah_num"], :name => "quran_page_image_ibfk_1"

  add_foreign_key "quran_struct_juz", ["surah_num"], "quran_struct_surah", ["surah_num"], :name => "quran_struct_juz_ibfk_1"

  add_foreign_key "quran_struct_sajda_tilawa", ["surah_num"], "quran_struct_surah", ["surah_num"], :name => "quran_struct_sajda_tilawa_ibfk_1"

  add_foreign_key "quran_struct_surah_ruku", ["surah_num"], "quran_struct_surah", ["surah_num"], :name => "quran_struct_surah_ruku_ibfk_1"

  add_foreign_key "quran_subject", ["quran_id"], "quran", ["id"], :name => "quran_subject_ibfk_1"
  add_foreign_key "quran_subject", ["parent_id"], "quran_subject", ["id"], :name => "quran_subject_ibfk_2"

  add_foreign_key "quran_subject_location", ["quran_subject_id"], "quran_subject", ["id"], :name => "quran_subject_location_ibfk_1"
  add_foreign_key "quran_subject_location", ["surah_num"], "quran_struct_surah", ["surah_num"], :name => "quran_subject_location_ibfk_2"

  add_foreign_key "quran_surah", ["quran_id"], "quran", ["id"], :name => "quran_surah_ibfk_1"
  add_foreign_key "quran_surah", ["surah_num"], "quran_struct_surah", ["surah_num"], :name => "quran_surah_ibfk_2"

end