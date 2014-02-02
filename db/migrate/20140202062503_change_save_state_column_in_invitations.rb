class ChangeSaveStateColumnInInvitations < ActiveRecord::Migration
  def change
    remove_column :student_entries, :save_state
    add_column :student_entries, :validation_bypass, :boolean, :default => false
  end
end
