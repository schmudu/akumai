class AddCodeToInvitations < ActiveRecord::Migration
  def change
    remove_index :invitations, :ticket
    remove_column :invitations, :ticket
    add_column :invitations, :code, :string
    add_index :invitations, :code, :unique => true
  end
end
