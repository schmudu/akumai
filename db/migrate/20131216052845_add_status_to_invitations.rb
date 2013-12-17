class AddStatusToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :status, :integer, default: 0
    add_index :invitations, :status
  end
end
