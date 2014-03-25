class InviteMailer < ActionMailer::Base
  include ConstantsHelper
  default from: "from@example.com"

  after_action :set_sent_status

  def send_user_registered invite
    @invite = invite
    mail(to: invite.email, subject: "TRIO - Invitation")
  end

  def send_user_unregistered invite
    query_params = {id: invite.slug, code: invite.code, email: invite.email}.to_query
    @link = "#{invites_signup_url}?#{query_params}"
    @invite = invite
    mail(to: invite.email, subject: "TRIO - Invitation")
  end

  private
    def set_sent_status
      @invite.update_attribute(:status, ConstantsHelper::INVITE_STATUS_SENT)
    end
end
