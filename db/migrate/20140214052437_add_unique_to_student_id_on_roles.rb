class AddUniqueToStudentIdOnRoles < ActiveRecord::Migration
  def change
  	add_index :roles, :student_id
  end
end
