require_relative '../../app/helpers/constants_helper'

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

  def staff_level_programs
    # return all program if superuser
    return Program.all.to_a if self.is_superuser?

    # only return staff level programs
    user_level_range = ConstantsHelper::ROLE_LEVEL_STAFF..ConstantsHelper::ROLE_LEVEL_SUPERUSER
    Program.joins(:roles).where(roles: {user_id: self.id, level:user_level_range}).to_a
  end
end
