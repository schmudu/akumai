require_relative '../helpers/constants_helper'

class Invitation < ActiveRecord::Base
  #attr_accessor :recipient_email
  extend FriendlyId
  friendly_id :code, use: :slugged

  belongs_to :program
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"

  validates :sender_id, presence: true
  validates :program_id, presence: true
  validates :user_level, presence: true
  validate :presence_of_email_or_recipient, :existence_of_program, :user_level_value, :user_does_not_have_role_in_program

  #callbacks
  after_validation :create_code

  def recipient
    return recipient_email unless recipient_email.blank?
    user = User.find_by_id(recipient_id)
  end

  # Friendly_Id code to only update the url for new records
  def should_generate_new_friendly_id?
    self.new_record?
  end

  private
    def create_code
      self.code = generate_code
    end

    def generate_code
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      (0...10).map{ o[rand(o.length)] }.join
    end

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

    def user_does_not_have_role_in_program
      # validate params
      return if program_id.nil?
      return if (((recipient_id.nil?) || (recipient_id.blank?)) && ((recipient_email.nil?) || (recipient_email.blank?)))

      # validate program param
      program = Program.find_by_id(self.program_id)
      return if program.nil?

      puts("\nvalidation check email:#{self.recipient_email} id:#{self.recipient_id}\n")
      if (self.recipient_id.nil?)
        puts("going to check recipient_email")
        # check invitation by email
        user = User.where("email = ?", self.recipient_email)
        return if user.empty?
        role = Role.where("program_id = ? and user_id = ?", self.program_id, user.first.id)
        errors[:role_in_program] = I18n.t('invitations.form.errors.user_already_in_program', email: user.first.email, program_name: program.name) unless role.empty?
      else
        puts("going to check recipient_id:#{self.recipient_id}:")
        # check invitation by recipient_id
        role = Role.where("program_id = ? and user_id = ?", self.program_id, recipient_id)
        user = User.find_by_id(self.recipient_id)
        unless role.empty?
          errors[:role_in_program] = I18n.t('invitations.form.errors.user_already_in_program', email: user.email, program_name: program.name)
        end
      end
    end
end
