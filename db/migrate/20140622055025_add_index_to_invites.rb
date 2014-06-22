class AddIndexToInvites < ActiveRecord::Migration
  def change
    add_index :invites, :student_id
  end
end
