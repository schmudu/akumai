module FailureJob
  def on_failure_retry(e, id)
    resource = get_resource id
    if resource.resque_attempts < ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS
      Resque.enqueue self, id
      resource.increment_attempts
    else
      Error.create(:resource => resource.class.name, :comment => "#{resource.class.name} id:#{id} perform failed via Resque #{ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS} times.")

      # call method to perform any additional executions if it exists
      self.after_failure if self.respond_to?(:after_failure)
    end
  end
end