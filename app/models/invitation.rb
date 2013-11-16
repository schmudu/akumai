class Invitation < ActiveRecord::Base
  attr_accessor :recipient_email

  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"

  validates :sender_id, presence: true
  #validates :recipient_id, presence: true
  validate :presence_of_email_or_recipient

  private
    def presence_of_email_or_recipient
      errors.add(:email, "email and recipient cannot both be set") if ((!recipient.nil?) && (!email.blank?))
      errors.add(:email, "email or recipient must be set") if ((recipient.nil?) && (email.blank?))
    end
end
