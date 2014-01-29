require_relative '../helpers/constants_helper'

class Invitation < ActiveRecord::Base
  #attr_accessor :recipient_email
=begin
  extend FriendlyId
  friendly_id :code, use: :slugged
=end

  belongs_to :program
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"

=begin
  validates :sender_id, presence: true
  validates :program_id, presence: true
  validates :user_level, presence: true
  validate :admin_and_staff_must_not_have_student_id,
            :existence_of_program, 
            :presence_of_email_or_recipient, 
            :student_role_must_have_student_id,
            :user_level_value, 
            :user_does_not_have_role_in_program, 
            :user_does_not_have_duplicate_invitation 
=end

  #callbacks
  #after_validation :create_code
  #before_create :create_code

  def recipient
    return recipient_email unless recipient_email.blank?
    user = User.find_by_id(recipient_id)
  end

  # Friendly_Id code to only update the url for new records
  def should_generate_new_friendly_id?
    new_record? || slug.blank?
  end

  private
    def create_code
      self.code = generate_code
    end

    def generate_code
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      code = (0...10).map{ o[rand(o.length)] }.join
      #puts "\nGENERATING CODE:#{code}"
      return code
    end

    def user_level_value
      errors.add(:user_level, "is not a valid value") if ((!user_level.nil?) && ((user_level < ConstantsHelper::ROLE_LEVEL_STUDENT) || (user_level > ConstantsHelper::ROLE_LEVEL_ADMIN)))
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

      if (self.recipient_id.nil?)
        # check invitation by email
        users = User.where("email = ?", self.recipient_email)
        return if users.empty?
        roles = Role.where("program_id = ? and user_id = ?", self.program_id, users.first.id)
      else
        # check invitation by recipient_id
        roles = Role.where("program_id = ? and user_id = ?", self.program_id, recipient_id)
        users = User.where("id = ?", self.recipient_id)
      end

      errors[:error_role_in_program] = I18n.t('invitations.form.errors.user_already_in_program', email: users.first.email, program_name: program.name) unless roles.empty?
    end

    def user_does_not_have_duplicate_invitation
      # return error if user already has an outstanding invitation to program
      return if program_id.nil?
      return if (((recipient_id.nil?) || (recipient_id.blank?)) && ((recipient_email.nil?) || (recipient_email.blank?)))

      # validate program param
      program = Program.find_by_id(self.program_id)
      return if program.nil?

      if (recipient_id.nil?)
        # check invitations by email (i.e. emails that haven't been registered)
        invitations = Invitation.where("program_id = ? and recipient_email = ? and status = ?", program_id, recipient_email, ConstantsHelper::INVITATION_STATUS_SENT)
        user_email = recipient_email
      else
        # check invitations by id
        invitations = Invitation.where("program_id = ? and recipient_id = ? and status = ?", program_id, recipient_id, ConstantsHelper::INVITATION_STATUS_SENT)
        user_email = User.where("id=?", self.recipient_id).first.email
      end

      errors[:error_duplicate_invitation] = "true" unless invitations.empty?
    end

    def admin_and_staff_must_not_have_student_id
      errors.add(:student_id, "student id must not be set for admin nor staff") if ((!user_level.nil?) && ((user_level == ConstantsHelper::ROLE_LEVEL_ADMIN) || (user_level == ConstantsHelper::ROLE_LEVEL_STAFF)) && (!student_id.nil?))
    end

    def student_role_must_have_student_id
      errors.add(:student_id, "student id must be set") if ((!user_level.nil?) && (user_level == ConstantsHelper::ROLE_LEVEL_STUDENT) && (student_id.nil?))
    end
end
