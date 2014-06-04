class CreateMappedCourses < ActiveRecord::Migration
  def change
    create_table :mapped_courses do |t|
      t.string :name
      t.integer :core_course_id
      t.integer :program_id

      t.timestamps
    end

    add_index :mapped_courses, :name
    add_index :mapped_courses, :program_id
    add_index :mapped_courses, :core_course_id
  end
end
