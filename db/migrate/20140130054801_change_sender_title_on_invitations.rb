class ChangeSenderTitleOnInvitations < ActiveRecord::Migration
  def change
    rename_column :invitations, :sender_id, :creator_id
  end
end
