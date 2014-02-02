class StudentEntry < ActiveRecord::Base
  include UsersHelper
  # note: column "validation_bypass" denotes whether the user has saved the student_entry
  #       this means that the student_entry is saved and has bypassed the validation stages
  #       however in order to be in actual use, the validation_bypass must be set to false.
  #       validation_bypass will only be set to true if the user saves the invitation and consequently
  #       the student entries.
  validates_presence_of :invitation_id
  validates_presence_of :email, if: "!validation_bypass"
  validates_presence_of :student_id, if: "!validation_bypass"
  validate :email_validation, if: "!validation_bypass"
  validates_uniqueness_of :student_id, :scope => :invitation_id, if: "!validation_bypass"
  validates_uniqueness_of :email, :scope => :invitation_id, if: "!validation_bypass"

  private
    def email_validation
      errors[:email] = I18n.t('invitations.form.errors.email_format') unless valid_email? email
    end
end
