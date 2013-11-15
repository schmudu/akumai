class AddRegisteredAttributeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registered, :boolean, default: false
    add_index :users, :registered
  end
end
