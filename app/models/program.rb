class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  # TODO - test destroy attributes
  has_many :invitations
  has_many :roles
  has_many :users, through: :roles

  validates :name, presence: true
  validates :name, :format => { with: /\A[a-zA-Z0-9\s\_\'\&\(\)\:]+\z/, message: "only letters, numbers, spaces, and special characters '&():"}
end
