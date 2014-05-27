class CreateCoreCourses < ActiveRecord::Migration
  def change
    create_table :core_courses do |t|
      t.string :name

      t.timestamps
    end

    add_index :core_courses, :name
  end
end
