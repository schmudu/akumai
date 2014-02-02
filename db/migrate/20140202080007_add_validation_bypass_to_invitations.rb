class AddValidationBypassToInvitations < ActiveRecord::Migration
  def change
  	add_column :invitations, :validation_bypass, :boolean, :default => false
  end
end
