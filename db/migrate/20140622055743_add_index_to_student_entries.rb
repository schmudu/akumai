class AddIndexToStudentEntries < ActiveRecord::Migration
  def change
    add_index :student_entries, :student_id
  end
end
