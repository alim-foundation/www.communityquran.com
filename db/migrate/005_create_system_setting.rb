class CreateSystemSetting < ActiveRecord::Migration
  def self.up
    create_table :system_setting do |t|
      t.column :name,   :string,  :null => false, :limit => 255
      t.column :value,  :text,    :null => false
    end

    add_index :system_setting, [:name], :unique => true
  end

  def self.down
    drop_table :system_setting
  end
end
