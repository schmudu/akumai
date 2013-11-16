class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :email, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :roles
  has_many :programs, through: :roles
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id"
  has_many :received_invitations, class_name: "Invitation", foreign_key: "recipient_id"

  def is_superuser?
    (superuser == true) ? true : false
  end
end
