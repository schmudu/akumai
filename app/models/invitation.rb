require_relative '../helpers/constants_helper'

class Invitation < ActiveRecord::Base
  #attr_accessor :recipient_email
  extend FriendlyId
  friendly_id :sender_id, use: :slugged

  belongs_to :program
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"

  validates :sender_id, presence: true
  validates :program_id, presence: true
  validates :user_level, presence: true
  validate :presence_of_email_or_recipient, :existence_of_program, :user_level_value

  def recipient
    return recipient_email unless recipient_email.blank?
    user = User.find_by_id(recipient_id)
  end

  # Friendly_Id code to only update the url for new records
  def should_generate_new_friendly_id?
    #new_record? || slug.blank?
    true
  end

  private
    def user_level_value
      errors.add(:user_level, "is not a valid value") if ((!user_level.nil?) && ((user_level < ConstantsHelper::ROLE_LEVEL_STUDENT) || (user_level > ConstantsHelper::ROLE_LEVEL_SUPERUSER)))
    end

    def existence_of_program
      program = Program.find_by_id(program_id)
      errors.add(:program_id, "program id does not reference a program") if program.nil?
    end

    def presence_of_email_or_recipient
      errors.add(:recipient_email, "recipient_email and recipient id cannot both be set") if ((!recipient_id.nil?) && (!recipient_email.blank?))
      errors.add(:recipient_email, "recipient_email or recipient id must be set") if ((recipient.nil?) && (recipient_email.blank?))
    end
end
