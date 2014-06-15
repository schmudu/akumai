class CreateCustomErrors < ActiveRecord::Migration
  def change
    create_table :custom_errors do |t|
      t.string :resource
      t.string :comment
      t.integer :program_id

      t.timestamps
    end
  end
end
