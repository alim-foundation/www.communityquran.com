module RedHillConsulting::Core::ActiveRecord::ConnectionAdapters
  module AbstractAdapter
    def self.included(base)
      base.module_eval do
        alias_method_chain :drop_table, :redhillonrails_core
      end
    end

    def foreign_keys(table_name, name = nil)
      []
    end

    def reverse_foreign_keys(table_name, name = nil)
      []
    end

    def add_foreign_key(table_name, column_names, references_table_name, references_column_names, options = {})
      foreign_key_name = options[:name] || "fkey_#{table_name}_on_#{Array(column_names) * '_and_'}"
      foreign_key = ForeignKeyDefinition.new(foreign_key_name, nil, column_names, ActiveRecord::Migrator.proper_table_name(references_table_name), references_column_names, options[:on_update], options[:on_delete])
      execute "ALTER TABLE #{table_name} ADD #{foreign_key}"
    end

    def remove_foreign_key(table_name, foreign_key_name)
      execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{foreign_key_name}"
    end

    def drop_table_with_redhillonrails_core(name, options = {})
      reverse_foreign_keys(name).each { |foreign_key| remove_foreign_key(foreign_key.table_name, foreign_key.name) }
      drop_table_without_redhillonrails_core(name, options)
    end
  end
end
