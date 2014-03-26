class RegistrationMailer < ActionMailer::Base
  include ConstantsHelper
  default from: "no-reply@akumai.org"

  def send_new_registration user
    @user = user
    mail(to: user.email, subject: "Akumai - Registration")
  end
end
