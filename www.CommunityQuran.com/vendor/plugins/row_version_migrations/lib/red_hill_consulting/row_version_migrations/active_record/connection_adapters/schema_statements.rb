module RedHillConsulting::RowVersionMigrations::ActiveRecord::ConnectionAdapters
  module SchemaStatements
    def self.included(base)
      base.module_eval do
        alias_method_chain :create_table, :row_version_migrations
      end
    end

    def create_table_with_row_version_migrations(name, options = {})
      create_table_without_row_version_migrations(name, options) do |table_defintion|
        yield table_defintion
        unless ActiveRecord::Schema.defining? || options[:row_version] == false
          table_defintion.column :created_at,   :datetime,  :null => false
          table_defintion.column :updated_at,   :datetime,  :null => false
          table_defintion.column :lock_version, :integer,   :null => false, :default => 0
        end
      end
    end
  end
end
