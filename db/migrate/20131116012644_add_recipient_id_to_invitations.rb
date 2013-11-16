class AddRecipientIdToInvitations < ActiveRecord::Migration
  def change
    remove_column :invitations, :to_user_id
    add_column :invitations, :recipient_id, :integer
    add_index :invitations, :recipient_id
  end
end
