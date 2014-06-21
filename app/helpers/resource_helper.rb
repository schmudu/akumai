module ResourceHelper
  # NOTE: in order to use this helper, the resource must implement get_resource method
  def process_resource id
    resource = get_resource id
    resource.update_attribute(:processed, true) unless resource.nil?
  end
end