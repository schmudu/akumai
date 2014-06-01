class CreateDatasetEntries < ActiveRecord::Migration
  def change
    create_table :dataset_entries do |t|
      t.integer :role_id
      t.string :data
      t.integer :dataset_id
      t.date :date

      t.timestamps
    end
  end
end
