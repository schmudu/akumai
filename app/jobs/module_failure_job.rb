module FailureJob
  def on_failure_retry(e, id)
    resource = get_resource id
    if resource.resque_attempts < ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS
      Resque.enqueue self, id
      resource.increment_attempts
    else
      # TODO - find a way to link errors to multiple resource, 
      # invites, programs, etc.
      Error.create(:resource => "Invite", :comment => "Invite id:#{id} perform failed via Resque #{ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS} times.")
    end
  end
end