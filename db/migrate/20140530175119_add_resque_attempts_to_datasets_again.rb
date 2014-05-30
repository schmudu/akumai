class AddResqueAttemptsToDatasetsAgain < ActiveRecord::Migration
  def change
    add_column :datasets, :resque_attempts, :integer, default: 0
    add_index :datasets, :resque_attempts
  end
end
