namespace :db do
    desc "Drop and create the current database"
    task :recreate => :environment do
        abcs = ActiveRecord::Base.configurations
        ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
        ActiveRecord::Base.connection.recreate_database(ActiveRecord::Base.connection.current_database)
    end
end