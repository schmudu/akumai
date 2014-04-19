class Dataset < ActiveRecord::Base
  include ValidResourceHelper

  belongs_to :program
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  validates_presence_of :attachment
  validates_presence_of :creator_id
  validates_presence_of :effective_at
  validates_presence_of :program_id
  validate :existence_of_creator,
            :existence_of_program

  # DEPLOYMENT
  # has_attached_file :attachment

  # DEVELOPMENT
  has_attached_file :attachment,
    :path => '/tmp/akumai-dev/paperclip/:class/:attachment/:id_partition/:style/:filename',
    :url => '/tmp/akumai-dev/paperclip/:class/:attachment/:id_partition/:style/:filename'
  validates_attachment :attachment, content_type: { content_type: "text/csv" }
end
