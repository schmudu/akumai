class AddStudentIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :student_id, :string
  end
end
