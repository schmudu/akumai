class CreateStudentEntries < ActiveRecord::Migration
  def change
    create_table :student_entries do |t|
      t.string :email, :default => ""
      t.string :student_id, :default => ""
      t.boolean :save_state, :default => false
      t.integer :invitation_id

      t.timestamps
    end

    add_index :student_entries, :invitation_id
  end
end
