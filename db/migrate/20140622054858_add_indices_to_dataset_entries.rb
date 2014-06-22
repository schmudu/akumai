class AddIndicesToDatasetEntries < ActiveRecord::Migration
  def change
    add_index :dataset_entries, :role_id
    add_index :dataset_entries, :dataset_id
  end
end
