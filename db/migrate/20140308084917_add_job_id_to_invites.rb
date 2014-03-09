class AddJobIdToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :job_id, :integer, default: 0
    add_index :invites, :job_id
  end
end
