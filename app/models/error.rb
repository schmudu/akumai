class Error < ActiveRecord::Base
  validates_presence_of :resource, :comment
end
