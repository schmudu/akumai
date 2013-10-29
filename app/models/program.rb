class Program < ActiveRecord::Base
  validates :name, presence: true
  validates :name, :format => { with: /\A[a-zA-Z0-9\s\_]+\z/, message: "only letters"}
end
