class Dataset < ActiveRecord::Base
  has_attached_file :attachment,
    :path => "/:rails_root/public/:attachment/:id/:basename.:extentsion"
  validates_attachment :attachment, content_type: { content_type: "text/plain" }
end
