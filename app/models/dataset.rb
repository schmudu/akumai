class Dataset < ActiveRecord::Base
  # DEPLOYMENT
  # has_attached_file :attachment

  # DEVELOPMENT
  has_attached_file :attachment,
    :path => '/tmp/akumai-dev/paperclip/:class/:attachment/:id_partition/:style/:filename',
    :url => '/tmp/akumai-dev/paperclip/:class/:attachment/:id_partition/:style/:filename'
  validates_attachment :attachment, content_type: { content_type: "text/plain" }
end
