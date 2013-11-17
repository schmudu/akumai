class AddProgramIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :program_id, :integer
    add_index :invitations, :program_id
  end
end
