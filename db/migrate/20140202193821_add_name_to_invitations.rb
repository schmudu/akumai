class AddNameToInvitations < ActiveRecord::Migration
  def change
  	add_column :invitations, :name, :string, :default => ""
  end
end
