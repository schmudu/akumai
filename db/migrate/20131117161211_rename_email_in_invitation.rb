class RenameEmailInInvitation < ActiveRecord::Migration
  def change
    remove_column :invitations, :email
    add_column :invitations, :recipient_email, :string
  end
end
