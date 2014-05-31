class Dataset < ActiveRecord::Base
  include ValidResourceHelper
  include ResqueResourceHelper

  belongs_to :program
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  after_create :process
  validates_presence_of :attachment
  validates_presence_of :creator_id
  validates_presence_of :program_id
  validate :existence_of_creator,
            :existence_of_program

  # PRODUCTION
=begin
  has_attached_file :attachment
=end

  # DEVELOPMENT
  has_attached_file :attachment,
    :path => '/tmp/akumai-dev/paperclip/:class/:attachment/:id_partition/:style/:filename',
    :url => '/tmp/akumai-dev/paperclip/:class/:attachment/:id_partition/:style/:filename'

  # TODO: using Rspec csv is viewed as plain but during development it's seen as a csv file
  validates_attachment_content_type :attachment, :content_type => /text\/(csv|plain)$/

  private
    def process
      Resque.enqueue(DatasetCreationJob, self.id)
    end
end
