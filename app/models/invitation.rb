class Invitation < ActiveRecord::Base
  attr_accessor :recipient_email

  belongs_to :user
  has_one :recipient, class_name: "User", foreign_key: "invitation_recipient_id"

  validates :user_id, presence: true
  validate :presence_of_email_or_recipient

  after_save :save_recipient_reference

  private
    def presence_of_email_or_recipient
      user_recipient = User.find_by_email(recipient_email)
      errors.add(:email, "email or recipient must be set") if ((user_recipient.nil?) && (email.blank?))
    end

    def save_recipient_reference
      return if recipient_email.nil?

      # save recipient however need to save multiple instances, create a table that relates invitations to user.
      user_recipient = User.find_by_email(recipient_email)
      user_recipient.invitation_recipient_id = self.id
      user_recipient.save
    end
end
