class DatasetCreationJob
  extend FailureJob

  @queue = :dataset

  def self.perform(id)
    dataset = get_resource id
    # do something with dataset
  end

  def self.get_resource id
    Dataset.find_by_id id
  end
end