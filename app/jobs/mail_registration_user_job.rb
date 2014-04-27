class MailRegistrationUserJob

  @queue = :mail

  def self.perform(id)
    user = get_resource id
    RegistrationMailer.send_new_registration(user).deliver
  end

  def self.get_resource id
    User.find_by_id id
  end
end