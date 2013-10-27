class Program < ActiveRecord::Base
  validates :name, presence: true
  validates :name, :format => { with: /\A[a-zA-Z0-7\s]+\z/, message: "only letters"}
end
