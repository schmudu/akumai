class DropErrorsTable < ActiveRecord::Migration
  def change
    remove_index :errors, :resource
    drop_table :errors
  end
end
