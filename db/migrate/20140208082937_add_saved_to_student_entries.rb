class AddSavedToStudentEntries < ActiveRecord::Migration
  def change
  	remove_column :student_entries, :validation_bypass
  	add_column :student_entries, :saved, :boolean, :default => false
  end
end
