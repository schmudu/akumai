class AddEffectiveAtToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :effective_at, :datetime
  end
end
