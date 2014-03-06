class Invite < ActiveRecord::Base
  extend FriendlyId
  friendly_id :email, use: :slugged
  
  include UsersHelper
  belongs_to :invitation

  before_validation :generate_code
  after_create :send_invite
  
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

    def generate_code
      return unless new_record?
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      self.code = (0...10).map{ o[rand(o.length)] }.join
    end

    def validate_email
      return if email.blank?
      errors.add(:base, I18n.t('invitations.form.errors.email_format')) unless valid_email? email
    end

    def is_for_student?
      return true if user_level == ConstantsHelper::ROLE_LEVEL_STUDENT
      false
    end

    def send_invite
      logger.info "=====SENDING INVITE:\n\n"
      registered_user = User.where("email = ?", self.email)
      if registered_user.empty?
        InviteMailer.send_user_registered(self).deliver
      else
        InviteMailer.send_user_unregistered(self).deliver
      end
    end
end
