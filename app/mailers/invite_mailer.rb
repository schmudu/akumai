class InviteMailer < ActionMailer::Base
  include ConstantsHelper
  default from: "from@example.com"

  def send_user_registered invite
    @invite_code = invite.code
    @invite_id = invite.slug
    mail(to: invite.email, subject: "Does this work?")
  end

  def send_user_unregistered invite
    @invite_code = invite.code
    @invite_id = invite.slug
    puts "sending unregistered invite"
    mail(to: invite.email, subject: "Does this unregistered work?")
  end
end
