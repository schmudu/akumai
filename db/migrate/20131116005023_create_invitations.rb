class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|

      t.timestamps
    end

    add_column :invitations, :user_id, :integer
    add_index :invitations, :user_id
  end
end
