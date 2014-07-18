class AddMappedCourseIdToDatasetEntry < ActiveRecord::Migration
  def change
    add_column :dataset_entries, :mapped_course_id, :integer
    add_index :dataset_entries, :mapped_course_id
  end
end
