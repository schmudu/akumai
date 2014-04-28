class MailInviteUserUnregisteredJob
  extend FailureJob

  @queue = :mail

  def self.perform(id)
    # raise error to do any test validation
    #raise "test exception to throw failure"
  end

  def self.get_resource id
    Invite.find_by_id id
  end
end