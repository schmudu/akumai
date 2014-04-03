class AddCreatorIdToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :creator_id, :integer
    add_index :datasets, :creator_id
  end
end
