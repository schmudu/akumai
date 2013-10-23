class RemoveTypeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :type 
    add_column :users, :user_type, :integer, default: 0
    add_index :users, :user_type
  end
end
