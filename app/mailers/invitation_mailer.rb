class InvitationMailer < ActionMailer::Base
  default from: "notifications@trios.com"

  def invitation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
