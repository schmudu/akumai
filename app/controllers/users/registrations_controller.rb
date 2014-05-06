class Users::RegistrationsController < Devise::RegistrationsController
  def sign_up(resource_name, resource)
    super(resource_name, resource)
    debugger
    Resque.enqueue(MailRegistrationUserJob, resource.id)
  end
end