class ChangeDefaultOfProcessedInDatasets < ActiveRecord::Migration
  def change
    remove_index :datasets, :processed
    remove_column :datasets, :processed
    add_column :datasets, :processed, :boolean, :default => false
    add_index :datasets, :processed
  end
end
