class DatasetEntry < ActiveRecord::Base
  include ValidResourceHelper

  belongs_to :dataset
  belongs_to :mapped_course
  belongs_to :role

  validates_presence_of :data
  validates_presence_of :dataset_id
  validates_presence_of :date
  validates_presence_of :role_id
  validate :existence_of_dataset,
            :existence_of_role
end
