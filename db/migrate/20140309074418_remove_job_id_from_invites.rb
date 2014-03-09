class RemoveJobIdFromInvites < ActiveRecord::Migration
  def change
    remove_index :invites, :job_id
    remove_column :invites, :job_id
  end
end
