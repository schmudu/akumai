class Dataset < ActiveRecord::Base
  has_attached_file :attachment
  validates_attachment :attachment, content_type: { content_type: "text/plain" }
end
