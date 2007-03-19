# == Schema Information
# Schema version: 1
#
# Table name: quran_subject
#
#  id                      :integer(11)   not null, primary key
#  quran_id                :integer(11)   not null
#  quran_subject_letter_id :integer(11)   
#  parent_id               :integer(11)   
#  topic                   :string(384)   not null
#  full_topic_path         :string(1024)  not null
#  created_at              :datetime      not null
#  updated_at              :datetime      not null
#  lock_version            :integer(11)   default(0), not null
#

class QuranSubject < ActiveRecord::Base
    belongs_to :quran, :class_name => "Quran"
    has_many :locations, :class_name => "QuranSubjectLocation"

    acts_as_tree
    acts_as_ferret :fields => { :topic => {:store => :yes}, :quran_code => {:store => :yes} }

    def quran_code
        return quran.code
    end

    def self.full_text_search(q, options = {})
        return nil if q.nil? or q==""
        default_options = {:limit => 10, :page => 1}
        options = default_options.merge options

        # get the offset based on what page we're on
        options[:offset] = options[:limit] * (options.delete(:page).to_i-1)

        # now do the query with our options
        results = self.find_by_contents(q, options)
        return [results.total_hits, results]
    end
end
