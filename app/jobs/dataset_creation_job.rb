class DatasetCreationJob
  extend FailureJob

  @queue = :dataset

  def self.perform(id)
    dataset = get_resource id
    # TODO: do something with dataset
    s = Roo::CSV.new(dataset.attachment.url)
  end

  def self.get_resource id
    Dataset.find_by_id id
  end
end