class AddTicketToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :ticket, :string
    add_index :invitations, :ticket, :unique => true
  end
end
