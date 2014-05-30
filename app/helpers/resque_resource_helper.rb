module ResqueResourceHelper
  def increment_attempts
    self.update_attribute(:resque_attempts, resque_attempts+1)
  end
end