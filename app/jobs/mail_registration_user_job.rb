class MailRegistrationUserJob

  @queue = :mail

  def self.perform(id)
    user = User.find_by_id id
    debugger
    RegistrationMailer.send_new_registration(user).deliver
  end

=begin
  def self.get_resource id
    debugger
    User.find_by_id id
  end
=end
end