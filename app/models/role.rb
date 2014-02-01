class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  validates :user_id, presence: true
  validates :program_id, presence: true
  validates :level, presence: true
  validate :admin_and_staff_must_not_have_student_id, 
            :level_must_fall_within_range, 
            :program_id_must_exist, 
            :student_role_must_have_student_id,
            :user_id_must_exist 
  validates_uniqueness_of :user_id, :scope => :program_id
  validates_uniqueness_of :student_id, :scope => :program_id, if: Proc.new { |role| !role.student_id.nil?}

  def self.role_in_program(program_id, user_id)
    results = where("program_id=? and user_id=?", program_id, user_id)
    return ConstantsHelper::ROLE_LEVEL_NO_ROLE if results.empty?
    return results.first.level
  end

  private
    def level_must_fall_within_range
      errors.add(:level, "is not set correctly") if ((!level.nil?) && ((level < ConstantsHelper::ROLE_LEVEL_STUDENT) || (level > ConstantsHelper::ROLE_LEVEL_SUPERUSER)))
    end

    def program_id_must_exist
      program = Program.find_by_id(program_id)
      errors.add(:program_id, "must reference valid program") if program.nil?
    end

    def admin_and_staff_must_not_have_student_id
      errors.add(:student_id, "student id must not be set for admin nor staff") if ((!level.nil?) && ((level == ConstantsHelper::ROLE_LEVEL_ADMIN) || (level == ConstantsHelper::ROLE_LEVEL_STAFF)) && (!student_id.nil?))
    end

    def student_role_must_have_student_id
      errors.add(:student_id, "student id must be set") if ((!level.nil?) && (level == ConstantsHelper::ROLE_LEVEL_STUDENT) && (student_id.nil?))
    end

    def user_id_must_exist
      user = User.find_by_id(user_id)
      errors.add(:user_id, "must reference valid user") if user.nil?
    end
end
