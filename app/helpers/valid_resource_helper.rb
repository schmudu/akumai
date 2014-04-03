module ValidResourceHelper
  def existence_of_creator
    user_found = User.find_by_id(creator_id)
    errors.add(:creator_id, "creator id does not reference a user") if user_found.nil?
  end
  
  def existence_of_program
    program = Program.find_by_id(program_id)
    errors.add(:program_id, "program id does not reference a program") if program.nil?
  end
end