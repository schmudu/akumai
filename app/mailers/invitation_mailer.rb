class InvitationMailer < ActionMailer::Base
  include ConstantsHelper
  default from: ConstantsHelper::INVITE_SENDER_EMAIL
  after_action :set_mail_to_sent

  def invitation_email_new_user(sender_email, recipient_email, invitation_code, invitation_slug)
    @sender_email = sender_email
    @invitation_code = invitation_code
    @invitation_slug = invitation_slug
    mail(to: recipient_email, subject: I18n.t('invitations.email.title.invitation'))
  end

  def invitation_email_registered_user(sender_email, recipient_email, invitation_code, invitation_slug)
    @sender_email = sender_email
    @invitation_code = invitation_code
    @invitation_slug = invitation_slug
    mail(to: recipient_email, subject: I18n.t('invitations.email.title.invitation'))
  end

  private
    def set_mail_to_sent
      unless @invitation_slug.nil?
        # find invitation and set status to sent
        invitations = Invitation.where("slug=?", @invitation_slug)
        unless invitations.empty?
          invitation = invitations.first
          invitation.status = ConstantsHelper::INVITATION_STATUS_SENT
          invitation.save
        end
      end
    end
end
