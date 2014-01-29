class ChangeDefaultValuesInInvitations < ActiveRecord::Migration
  def change
    change_column_default :invitations, :user_level, 0
    change_column_default :invitations, :recipient_emails, "" 
  end
end
