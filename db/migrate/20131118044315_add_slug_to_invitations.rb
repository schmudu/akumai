class AddSlugToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :slug, :string
    add_index :invitations, :slug, unique: true
  end
end
