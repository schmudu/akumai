require_relative '../helpers/constants_helper'
require_relative '../helpers/users_helper'

class Invitation < ActiveRecord::Base
  extend FriendlyId
  include UsersHelper
  friendly_id :status, use: :slugged

  belongs_to :program
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :student_entries, dependent: :destroy
  has_many :invites, dependent: :destroy
  accepts_nested_attributes_for :student_entries, 
      reject_if: lambda { |attr| ((attr[:email].blank? && attr[:student_id].blank?) || Invitation.duplicate_entry(attr[:invitation_id], attr[:email], attr[:student_id])) }
        


  # validation rules
  # during stage TYPE: validate creator_id, name, program_id, and user_level
  # during stage ADDRESSES: validate recipient_emails or student entries
  # during stage ADDRESSES: user can bypass validation if they want to save their progress (see saved column)
  # during stage REVIEW: all attributes need to be validated
  # general validation
  
  validates_presence_of :creator_id, :program_id, :name
  validate :has_only_email_recipients_or_student_entries,
            :existence_of_program,
            :existence_of_creator,
            :creator_privileges

  # stage validation - type
  validate :non_existence_of_email_recipients, if: "is_stage_type?"

  # stage validation - beyond type
  validate :invitation_types_have_correct_addresses, if: "is_passed_stage_type?"

  # stage validation - address
  validate :has_at_least_one_student_entry, if: "is_passed_stage_type?"
  validate :has_valid_saved_addresses, if: "is_passed_stage_type?"

  # stage validation - review
  validate :not_in_saved_state, if: "is_stage_review?"
  validate :non_existence_of_student_entries_in_saved_state, if: "is_stage_review?"
=begin
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

  def self.duplicate_entry(invitation_id, email, student_id)
    puts "\n\n=====invitation_id:#{invitation_id}"
    student_entries = StudentEntry.where("invitation_id = ? AND email = ? AND student_id = ?", invitation_id, email, student_id)
    return true unless student_entries.empty?
    false
  end

  def has_email_recipients?
    return false if (recipient_emails.nil? || recipient_emails.empty?)
    true
  end

  def has_student_entries?
    return true if student_entries.count > 0
    false
  end

  def recipient
    return recipient_email unless recipient_email.blank?
    user = User.find_by_id(recipient_id)
  end

  # Friendly_Id code to only update the url for new records
  def should_generate_new_friendly_id?
    new_record? || slug.blank?
  end

  def is_for_student?
    return true if user_level == ConstantsHelper::ROLE_LEVEL_STUDENT
    false
  end

  private
    def admin_and_staff_must_not_have_student_id
      errors.add(:student_id, "student id must not be set for admin nor staff") if ((!user_level.nil?) && ((user_level == ConstantsHelper::ROLE_LEVEL_ADMIN) || (user_level == ConstantsHelper::ROLE_LEVEL_STAFF)) && (!student_id.nil?))
    end

    def create_code
      self.code = generate_code
    end

    def creator_privileges
      return if (program_id.nil? || creator_id.nil?)
      return if creator.nil?
      return if creator.is_superuser?
      creator_role = Role.role_in_program(program_id, creator_id)

      # rules
      # students and someone that has no role cannot invite anyone
      # staff can only invite students
      # admin can invite anyone
      # superusers can invite anyone
      case creator_role
      when ConstantsHelper::ROLE_LEVEL_NO_ROLE
        errors.add(:creator_id, I18n.t('invitations.form.errors.invitation_type_invalid')) if ((creator_role == ConstantsHelper::ROLE_LEVEL_NO_ROLE) || (creator_role == ConstantsHelper::ROLE_LEVEL_STUDENT))
      when ConstantsHelper::ROLE_LEVEL_STUDENT
        errors.add(:creator_id, I18n.t('invitations.form.errors.invitation_type_invalid')) if ((creator_role == ConstantsHelper::ROLE_LEVEL_NO_ROLE) || (creator_role == ConstantsHelper::ROLE_LEVEL_STUDENT))
      when ConstantsHelper::ROLE_LEVEL_STAFF
        errors.add(:creator_id, I18n.t('invitations.form.errors.privileges_staff')) if ((user_level == ConstantsHelper::ROLE_LEVEL_STAFF) || (user_level == ConstantsHelper::ROLE_LEVEL_ADMIN))
      when ConstantsHelper::ROLE_LEVEL_ADMIN
        return
      end
        
=begin
      # students and those with no role cannot create invitations
      errors.add(:creator_id, I18n.t('invitations.form.errors.invitation_type_invalid')) if ((creator_role == ConstantsHelper::ROLE_LEVEL_NO_ROLE) || (creator_role == ConstantsHelper::ROLE_LEVEL_STUDENT))

      # student invitation valid since only staff or higher would get to this point
      return if (user_level == ConstantsHelper::ROLE_LEVEL_STUDENT)

      # staff invitation
      if (user_level == ConstantsHelper::ROLE_LEVEL_STAFF)
        errors.add(:creator_id, I18n.t('invitations.form.errors.privileges_staff')) if (creator_id == ConstantsHelper::ROLE_LEVEL_STAFF)
      end

      # admin invitation
      errors.add(:creator_id, I18n.t('invitations.form.errors.privileges_admin')) if ((creator_id != ConstantsHelper::ROLE_LEVEL_ADMIN) && (creator_id != ConstantsHelper::ROLE_LEVEL_SUPERUSER))
=end
    end

    def generate_code
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      code = (0...10).map{ o[rand(o.length)] }.join
      #puts "\nGENERATING CODE:#{code}"
      return code
    end

    def has_only_email_recipients_or_student_entries
      # cannot have invalid email recipients nor invalid student entries
      errors.add(:recipient_emails, I18n.t('invitations.form.errors.has_student_entries_and_email_recipients')) if ((has_student_entries?) && (has_email_recipients?))
    end

    def has_valid_saved_addresses
      if (saved == false)
        #no bypass
        if is_for_student?
=begin
          if (student_entries.count == 0)
            errors.add(:student_entries, I18n.t('invitations.form.errors.existence_student_entry'))
          else
=end
            student_entries.each do |entry|
              if (!entry.valid? || entry.saved)
                # if entry is invalid or is bypassing validation, then error b/c this invitation does not have bypass
                errors.add(:id, I18n.t('invitations.form.errors.has_invalid_student_entries')) 
                return
              end
            end
          #end
        else
          #email_recipients, need to validate
          result = self.valid_email_addresses?(recipient_emails)
          if ((result[:emails].nil?) || (result[:emails].count == 0))
            errors.add(:recipient_emails, I18n.t('invitations.form.errors.existence_email'))
          else
            errors.add(:recipient_emails, I18n.t('invitations.form.errors.email_format')) if (result[:valid] == false)
          end
        end
      end
    end

    def invitation_types_have_correct_addresses
      errors.add(:recipient_emails, I18n.t('invitations.form.errors.non_student_has_student_entries')) if ((!is_for_student?) && has_student_entries?)
      errors.add(:recipient_emails, I18n.t('invitations.form.errors.students_have_email_addresses')) if(is_for_student? && has_email_recipients?)
    end

    def is_passed_stage_type?
      return true if status > ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
      false
    end

    def is_stage_address?
      return true if status == ConstantsHelper::INVITATION_STATUS_SETUP_ADDRESS
      false
    end

    def is_stage_review?
      return true if status == ConstantsHelper::INVITATION_STATUS_SETUP_REVIEW
      false
    end

    def is_stage_type?
      return true if status == ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
      false
    end

    def user_level_value
      errors.add(:user_level, "is not a valid value") if ((!user_level.nil?) && ((user_level < ConstantsHelper::ROLE_LEVEL_STUDENT) || (user_level > ConstantsHelper::ROLE_LEVEL_ADMIN)))
    end

    def existence_of_program
      program = Program.find_by_id(program_id)
      errors.add(:program_id, "program id does not reference a program") if program.nil?
    end

    def existence_of_creator
      user_found = User.find_by_id(creator_id)
      errors.add(:creator_id, "creator id does not reference a user") if user_found.nil?
    end

    def non_existence_of_email_recipients
      errors.add(:recipient_emails, I18n.t('invitations.form.errors.non_existence_of_email_recipients')) if has_email_recipients?
    end

    def non_existence_of_student_entries_in_saved_state
      student_entries.each do |entry|
        errors.add(:id, I18n.t('invitations.form.errors.invitation_cannot_have_entries_with_saved_state')) if entry.saved == true
      end
    end

    def not_in_saved_state
      errors.add(:saved, I18n.t('invitations.form.errors.invitation_saved_state')) if saved == true
    end

    def presence_of_email_or_recipient
      errors.add(:recipient_email, "recipient_email and recipient id cannot both be set") if ((!recipient_id.nil?) && (!recipient_email.blank?))
      errors.add(:recipient_email, "recipient_email or recipient id must be set") if ((recipient.nil?) && (recipient_email.blank?))
    end

    def student_role_must_have_student_id
      errors.add(:student_id, "student id must be set") if ((!user_level.nil?) && (user_level == ConstantsHelper::ROLE_LEVEL_STUDENT) && (student_id.nil?))
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

    def has_at_least_one_student_entry
      #puts "\n\n==AFTER VALIDATION: status:#{status} student_entries:#{self.student_entries.reject(&:marked_for_destruction?).count}\n\n"
      if is_for_student?
        errors.add(:base, "Need to have at least one student entries") if self.student_entries.reject(&:marked_for_destruction?).count < 1
      end
    end
end
