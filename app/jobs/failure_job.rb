module FailureJob
  def on_failure_retry(e, id)
    resource = get_resource id
    if resource.resque_attempts < ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS
      Resque.enqueue self, id
      resource.increment_attempts
    else
      # call method to perform any additional executions if it exists
      if self.respond_to?(:after_failure)
        # specific error
        self.after_failure(e, id)
      else
        # generic error
        CustomError.create(:program_id => resource.program.id,
          :resource => resource.class.name, 
          :comment => "#{resource.class.name} id:#{id} perform failed via Resque #{ConstantsHelper::MAX_NUMBER_OF_ATTEMPTS} times. #{e.message}")
      end
    end
  end
end