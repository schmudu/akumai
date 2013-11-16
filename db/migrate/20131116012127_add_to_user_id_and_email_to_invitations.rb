class AddToUserIdAndEmailToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :email, :string
    add_column :invitations, :to_user_id, :integer
  end
end
