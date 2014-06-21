class AddProcessedFlagToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :processed, :boolean, :default => true
    add_index :datasets, :processed
  end
end
