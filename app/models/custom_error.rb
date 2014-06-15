class CustomError < ActiveRecord::Base
  belongs_to :program
  validates_presence_of :resource, :comment
end
