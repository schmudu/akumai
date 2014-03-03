class Invite < ActiveRecord::Base
  include UsersHelper
  belongs_to :invitation
  
  validates_presence_of :code, :email
  validates :user_level, :inclusion => ConstantsHelper::ROLE_LEVEL_STUDENT..ConstantsHelper::ROLE_LEVEL_ADMIN
  validate :validate_email

  private
    def validate_email
      return if email.blank?
      errors.add(:base, I18n.t('invitations.form.errors.email_format')) unless valid_email? email
    end
end
