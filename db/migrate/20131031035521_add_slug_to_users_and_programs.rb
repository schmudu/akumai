class AddSlugToUsersAndPrograms < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
    add_column :programs, :slug, :string
    add_index :programs, :slug, unique: true
  end
end
