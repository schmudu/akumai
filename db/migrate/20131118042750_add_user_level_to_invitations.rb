class AddUserLevelToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :user_level, :integer
  end
end
