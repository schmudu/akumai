class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true
  validates :name, :format => { with: /\A[a-zA-Z0-9\s\_\'\&\(\)\:]+\z/, message: "only letters, numbers, spaces, and special characters '&():"}
end
