class RemoveEffectiveDateFromDatasets < ActiveRecord::Migration
  def change
    remove_column :datasets, :effective_at
  end
end
