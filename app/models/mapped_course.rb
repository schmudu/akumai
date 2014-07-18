class MappedCourse < ActiveRecord::Base
  include CoursesHelper
  include ValidResourceHelper
  before_validation :scrub_name

  belongs_to :program
  belongs_to :core_course
  has_many :dataset_entries, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :program_id
  # core_course_id can be nil b/c if there is a data import and 
  # the mapped course has not been mapped to a core course then 
  # it will be nil
  #validates_presence_of :core_course_id
  validates_uniqueness_of :name, :scope => :program_id
  validate  :existence_of_program,
            :existence_of_core_course
end
