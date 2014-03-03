class ChangeStudentIdColumnName < ActiveRecord::Migration
  def change
    remove_column :invites, :student
    add_column :invites, :student_id, :string
  end
end
