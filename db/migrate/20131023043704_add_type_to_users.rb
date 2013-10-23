class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :integer, default: 0
  end
end
