class Invitation < ActiveRecord::Base
  #attr_accessor :recipient_email

  belongs_to :program
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  #belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"

  validates :sender_id, presence: true
  validates :program_id, presence: true
  validate :presence_of_email_or_recipient#, :existence_of_program

  def recipient
    return recipient_email unless recipient_email.blank?
    user = User.find_by_id(recipient_id)
  end

  private
    def presence_of_email_or_recipient
      errors.add(:recipient_email, "recipient_email and recipient id cannot both be set") if ((!recipient_id.nil?) && (!recipient_email.blank?))
      errors.add(:recipient_email, "recipient_email or recipient id must be set") if ((recipient.nil?) && (recipient_email.blank?))
    end
end
