class RemoveCodeFromPrograms < ActiveRecord::Migration
  def change
    remove_column :programs, :code
  end
end
