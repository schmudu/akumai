class AddSavedToInvitations < ActiveRecord::Migration
  def change
  	remove_column :invitations, :validation_bypass
  	add_column :invitations, :saved, :boolean, :default => false
  end
end
