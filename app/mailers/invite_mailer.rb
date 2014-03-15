class InviteMailer < ActionMailer::Base
  include ConstantsHelper
  default from: "from@example.com"

  def send_user_registered invite
    @invite = invite
    mail(to: invite.email, subject: "Does this work?")
  end

  def send_user_unregistered invite
    query_params = {id: invite.slug, code: invite.code, email: invite.email}.to_query
    @link = "#{invites_signup_url}?#{query_params}"
    @invite = invite
    mail(to: invite.email, subject: "Does this unregistered work?")
  end
end
