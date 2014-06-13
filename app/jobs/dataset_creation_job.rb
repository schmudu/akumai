class DatasetCreationJob
  extend FailureJob

  @queue = :dataset

  def self.convert_roles_to_hash roles
    h = Hash.new
    roles.each do |role|
      next if (role.student_id.nil? || role.student_id.blank?)
      h[role.student_id] = role.id
    end
    return h
  end

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
      dataset_row = Hash.new
      ((s.first_column+1)..s.last_column).each_with_index do |column, j|
        dataset_entry = Hash.new
        dataset_entry = {:date => dates[column-1], :student_id => student_ids[row-1], 
            :data => s.row(row)[column-1], :header => headers[column-1]}
        dataset_row[j] = dataset_entry
      end
      datasets[i] = dataset_row
    end

    # convert program roles to hash
    program_roles = self.convert_roles_to_hash(dataset.program.roles)

    #puts "===program_roles:#{datasets.inspect}\n\n"

    datasets.each do |dataset_row, row|
      row.each do |dataset_column, entry|
          next if entry[:data].nil?
          # find role from student_ids
          role_id = get_program_role_id(program_roles, entry[:student_id], dataset.program)

          new_entry = DatasetEntry.create(:date => entry[:date].to_datetime, 
              :role_id => role_id, 
              :data => entry[:data], 
              :dataset_id => id)

          #puts "==entry:#{new_entry.errors.inspect}\n"
      end
    end
  end

  def self.get_program_role_id(roles_hash, student_id, program)
    # get role or create if not found
    role_id = roles_hash[student_id]

    # check DB for role
    if role_id.nil?
      role = Role.where("program_id = ? and student_id = ?", program.id, student_id).first
      role_id = role.id
    end

    # create role
    if role_id.nil?
      # create role
      new_role = Role.create(:program_id => program.id, 
        :student_id => student_id,
        :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
      role_id = new_role.id
      puts "===new role id:#{role_id} errors:#{new_role.errors.inspect}\n\n"
    end

    return role_id
  end

  def self.get_resource id
    Dataset.find_by_id id
  end
end