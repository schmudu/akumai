class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :email, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :roles
  has_many :programs, through: :roles
  has_many :invitations
  belongs_to :invitation, foreign_key: "invitation_recipient_id"

  def is_superuser?
    (superuser == true) ? true : false
  end
end
