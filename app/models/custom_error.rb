class CustomError < ActiveRecord::Base
  include ValidResourceHelper
  belongs_to :program
  validates_presence_of :resource, :comment, :program_id
  validate :existence_of_program
end
