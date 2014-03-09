class AddResqueAttemtpsToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :resque_attempts, :integer, default: 0
    add_index :invites, :resque_attempts
  end
end
