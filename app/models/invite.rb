class Invite < ActiveRecord::Base
  extend FriendlyId
  friendly_id :status, use: :slugged
  
  include UsersHelper
  belongs_to :invitation
  
  validates_presence_of :code, :email, :invitation_id
  validates_presence_of :student_id, :if => :is_for_student?
  validates :user_level, :inclusion => ConstantsHelper::ROLE_LEVEL_STUDENT..ConstantsHelper::ROLE_LEVEL_ADMIN
  validate :validate_email,
    :existence_of_invitation

  private
    def existence_of_invitation
      result = Invitation.where("id = ?", invitation_id)
      errors.add(:base, "Invitation id does not reference an existing  invitation.") if result.empty?
    end

    def validate_email
      return if email.blank?
      errors.add(:base, I18n.t('invitations.form.errors.email_format')) unless valid_email? email
    end

    def is_for_student?
      return true if user_level == ConstantsHelper::ROLE_LEVEL_STUDENT
      false
    end
end
