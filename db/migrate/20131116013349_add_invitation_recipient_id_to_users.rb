class AddInvitationRecipientIdToUsers < ActiveRecord::Migration
  def change
    remove_index :invitations, :recipient_id
    remove_column :invitations, :recipient_id
    add_column :users, :invitation_recipient_id, :integer
    add_index :users, :invitation_recipient_id
  end
end
