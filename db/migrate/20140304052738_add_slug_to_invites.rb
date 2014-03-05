class AddSlugToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :slug, :string
    add_index :invites, :slug, unique: true
  end
end
