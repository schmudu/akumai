class AddProgramIdToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :program_id, :integer
    add_index :datasets, :program_id
  end
end
