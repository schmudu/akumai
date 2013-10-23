class AddSuperuserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :superuser, :boolean, default: false
    add_index :users, :superuser
  end
end
