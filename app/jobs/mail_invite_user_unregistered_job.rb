class MailInviteUserUnregisteredJob
  extend FailureJob

  @queue = :mail

  def self.perform(id)
    # raise error to do any test validation
    #raise "test exception to throw failure"
    invite = get_resource id
    InviteMailer.send_user_unregistered(invite).deliver
  end

  def self.after_failure(e, id)
    # any additional executions after failure to perform job
    invite = get_resource id
    CustomError.create(:program_id => invite.program.id,
      :resource => "Invite", 
      :comment => "#{invite.class.name} id:#{id} perform failed via Resque #{ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS} times. #{e.message}")
  end

  def self.get_resource id
    Invite.find_by_id id
  end
end