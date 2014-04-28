module FailureJob
  def on_failure_retry(e, id)
    resource = get_resource id
    if resource.resque_attempts < ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS
      Resque.enqueue self, id
      resource.increment_attempts
    else
      Error.create(:resource => resource.class.name, :comment => "#{resource.class.name} id:#{id} perform failed via Resque #{ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS} times.")
    end
  end
end