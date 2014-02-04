class StudentEntry < ActiveRecord::Base
  include UsersHelper
  # note: column "validation_bypass" denotes whether the user has saved the student_entry
  #       this means that the student_entry is saved and has bypassed the validation stages
  #       however in order to be in actual use, the validation_bypass must be set to false.
  #       validation_bypass will only be set to true if the user saves the invitation and consequently
  #       the student entries.
  belongs_to :invitation

  validates_presence_of :invitation_id
  validate :existence_of_invitation

  validate :either_email_or_student_id, if: "validation_bypass"
  validates_presence_of :email, if: "!validation_bypass"
  validate :email_validation, if: "!validation_bypass"
  validates_uniqueness_of :email, :scope => :invitation_id, if: "!validation_bypass"

  validates_presence_of :student_id, if: "!validation_bypass"
  validates_uniqueness_of :student_id, :scope => :invitation_id, if: "!validation_bypass"

  private
    def email_validation
      errors[:email] = I18n.t('invitations.form.errors.email_format') unless valid_email? email
    end

    def existence_of_invitation
      invitation = Invitation.find_by_id(invitation_id)
      errors.add(:invitation_id, I18n.t('invitations.form.errors.existence_invitation')) if invitation.nil?
    end

    def either_email_or_student_id
      errors.add(:student_id, I18n.t('student_entries.errors.either_student_id_or_email')) if ((student_id.nil?) && ((email.nil?) || (email.blank?)))
    end
end
