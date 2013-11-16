class Invitation < ActiveRecord::Base
  belongs_to :user
  has_one :recipient, class_name: "User", foreign_key: "invitation_recipient_id"

  validates :user_id, presence: true
  validate :presence_of_email_or_recipient

  private
    def presence_of_email_or_recipient
      errors.add(:email, "email or recipient must be set") if ((recipient.nil?) && (email.blank?))
    end
end
