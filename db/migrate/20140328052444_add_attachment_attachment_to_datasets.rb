class AddAttachmentAttachmentToDatasets < ActiveRecord::Migration
  def self.up
    change_table :datasets do |t|
      t.attachment :attachment
    end
  end

  def self.down
    drop_attached_file :datasets, :attachment
  end
end
