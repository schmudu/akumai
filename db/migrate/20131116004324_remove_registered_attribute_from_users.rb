class RemoveRegisteredAttributeFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :registered
    remove_column :users, :registered
  end
end
