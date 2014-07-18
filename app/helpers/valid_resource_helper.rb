module ValidResourceHelper
  def existence_of_core_course
    return if core_course_id.nil?
    found = CoreCourse.find_by_id(core_course_id)
    errors.add(:core_course_id, "core_course_id does not reference a core course.") if found.nil?
  end

  def existence_of_creator
    return if creator_id.nil?
    found = User.find_by_id(creator_id)
    errors.add(:creator_id, "creator id does not reference a user.") if found.nil?
  end

  def existence_of_dataset
    return if dataset_id.nil?
    found = Dataset.find_by_id(dataset_id)
    errors.add(:dataset_id, "dataset id does not reference a dataset.") if found.nil?
  end

  def existence_of_invitation
    return if invitation_id.nil?
    result = Invitation.where("id = ?", invitation_id)
    errors.add(:base, "Invitation id does not reference an existing invitation.") if result.empty?
  end

  def existence_of_program
    return if program_id.nil?
    found = Program.find_by_id(program_id)
    errors.add(:program_id, "program id does not reference a program.") if found.nil?
  end

  def existence_of_recipient
    return if recipient_id.nil? || recipient_id.blank?
    result = User.where("id = ?", recipient_id)
    errors.add(:base, "Recipient id does not reference an existing user.") if result.empty?
  end

  def existence_of_role
    return if role_id.nil?
    found = Role.find_by_id(role_id)
    errors.add(:role_id, "role id does not reference a role.") if found.nil?
  end
end