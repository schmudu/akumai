class DatasetCreationJob
  extend FailureJob

  @queue = :dataset

  def self.perform(id)
    dataset = get_resource id
    # TODO: test failure - I think it's self.on_failure hook
    s = Roo::CSV.new(dataset.attachment.url(:original, false))


    # The first cell(0,0)[first row, first column] must be blank
    # The second cell(0,1)[second row, first column] must be blank
    # Dates are required to be the first row (e.g. 10/25/2006)
    # Headers are required to be the second row (e.g. "Algebra 2")
    # Student IDs are required to be in the first column
    dates = Hash.new
    headers = Hash.new
    student_ids = Hash.new
    datasets = Hash.new

    # populate hashes for headers and dates
    s.row(1).each_with_index {|date, i| dates[i] = date }
    s.row(2).each_with_index {|header, i| headers[i] = header }
    s.column(1).each_with_index {|student_id, i| student_ids[i] = student_id }

    # iterate through all rows and columns for data
    ((s.first_row+2)..s.last_row).each_with_index do |row, i|
      ((s.first_column+1)..s.last_column).each_with_index do |column, j|
        dataset = Hash.new
        dataset = {:date => dates[column-1], :student_id => student_ids[row-1], :data => s.row(row)[column-1]}
        datasets[[j,i]] = dataset
      end
    end

    # value data is in datasets store in DatasetEntry
    # DatasetEntry (:date, :role_id, :data, :dataset_id)
=begin
    datasets.each do |dataset|
      next if dataset[:data].nil?

    end
=end
  end

  def self.get_resource id
    Dataset.find_by_id id
  end
end