class ChangeNameOfEmailRecipientsOnInvitations < ActiveRecord::Migration
  def change
    remove_column :invitations, :email_recipients
    add_column :invitations, :recipient_emails, :text
  end
end
