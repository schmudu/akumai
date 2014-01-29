class RemoveInvitationAttributesForRefactoring < ActiveRecord::Migration
  def change
    remove_index :invitations, :recipient_id
    remove_index :invitations, :code
    remove_column :invitations, :recipient_id 
    remove_column :invitations, :code 
    remove_column :invitations, :recipient_email 
    remove_column :invitations, :student_id 
  end
end
