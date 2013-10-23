class RemoveUserTypeFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :user_type
    remove_column :users, :user_type
  end
end
