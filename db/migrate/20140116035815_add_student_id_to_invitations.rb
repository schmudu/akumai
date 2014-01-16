class AddStudentIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :student_id, :string
  end
end
