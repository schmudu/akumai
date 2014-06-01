module ValidResourceHelper
  def existence_of_creator
    user_found = User.find_by_id(creator_id)
    errors.add(:creator_id, "creator id does not reference a user.") if user_found.nil?
  end

  def existence_of_dataset
    dataset_found = Dataset.find_by_id(dataset_id)
    errors.add(:dataset_id, "dataset id does not reference a dataset.") if dataset_found.nil?
  end
  
  def existence_of_program
    program = Program.find_by_id(program_id)
    errors.add(:program_id, "program id does not reference a program.") if program.nil?
  end

  def existence_of_role
    role_found = Role.find_by_id(role_id)
    errors.add(:role_id, "role id does not reference a user.") if role_found.nil?
  end
end