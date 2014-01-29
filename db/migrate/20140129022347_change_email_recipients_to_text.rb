class ChangeEmailRecipientsToText < ActiveRecord::Migration
  def change
    remove_column :invitations, :email_recipients
    add_column :invitations, :email_recipients, :text
  end
end
