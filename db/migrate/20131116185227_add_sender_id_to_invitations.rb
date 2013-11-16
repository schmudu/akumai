class AddSenderIdToInvitations < ActiveRecord::Migration
  def change
    remove_index :invitations, :user_id
    remove_column :invitations, :user_id
    add_column :invitations, :sender_id, :integer
    add_index :invitations, :sender_id
  end
end
