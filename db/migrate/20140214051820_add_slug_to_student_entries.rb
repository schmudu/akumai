class AddSlugToStudentEntries < ActiveRecord::Migration
  def change
  	add_column :student_entries, :slug, :string
  	add_index :student_entries, :slug, unique: true
  end
end
