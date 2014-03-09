class CreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.string :resource, :default => ""
      t.string :comment, :default => ""

      t.timestamps
    end

    add_index :errors, :resource
  end
end
