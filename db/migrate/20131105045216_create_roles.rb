class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :user_id
      t.integer :program_id

      t.timestamps
    end

    add_index :roles, :user_id
    add_index :roles, :program_id
  end
end
