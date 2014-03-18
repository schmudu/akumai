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

  def program
    self.invitation.program
  end

  def increment_attempts
    self.update_attribute(:resque_attempts, resque_attempts+1)
  end

  def is_for_student?
    return true if user_level == ConstantsHelper::ROLE_LEVEL_STUDENT
    false
  end

  def matches? (test_invite, test_student_id = false)
    # this only tests whether or not invite matches email, 
    # code and student_id (for student invites)
    match_email = test_invite.email == self.email ? true : false
    match_code = test_invite.code == self.code ? true : false
    match_student_id = test_invite.student_id == self.student_id ? true : false
    logger.info "matches? email:#{match_email} code:#{match_code} student_id:#{match_student_id}"
    if self.is_for_student? && test_student_id
      return true if (match_code && match_email && match_student_id)
    else
      return true if (match_code && match_email)
    end
    false
  end

  private
    def existence_of_invitation
      result = Invitation.where("id = ?", invitation_id)
      errors.add(:base, "Invitation id does not reference an existing  invitation.") if result.empty?
    end

    def generate_code
      return unless new_record?
      logger.info "\nGENERATING NEW CODE"
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      self.code = (0...10).map{ o[rand(o.length)] }.join
    end

    def validate_email
      return if email.blank?
      errors.add(:base, I18n.t('invitations.form.errors.email_format')) unless valid_email? email
    end

    def send_invite
      registered_user = User.where("email = ?", self.email)
      if registered_user.empty?
        Resque.enqueue(MailInviteUserUnregisteredJob, self.id)
      else
        InviteMailer.send_user_registered(self)
      end
    end
end