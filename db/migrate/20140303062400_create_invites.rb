class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :invitation_id
      t.string :student
      t.string :code
      t.string :email
      t.integer :user_level

      t.timestamps
    end

    add_index :invites, :invitation_id
  end
end
