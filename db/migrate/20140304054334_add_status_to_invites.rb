class AddStatusToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :status, :integer, default: 0
    add_index :invites, :status
  end
end
