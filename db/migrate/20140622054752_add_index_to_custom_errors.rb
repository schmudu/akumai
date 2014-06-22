class AddIndexToCustomErrors < ActiveRecord::Migration
  def change
    add_index :custom_errors, :program_id
  end
end
