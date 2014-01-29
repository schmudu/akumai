class AddEmailRecipientsToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :email_recipients, :string
  end
end
