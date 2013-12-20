class RemoveInvitationRecipientIdFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :invitation_recipient_id
    remove_column :users, :invitation_recipient_id
  end
end
