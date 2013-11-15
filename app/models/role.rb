class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  validates :user_id, presence: true
  validates :program_id, presence: true
  validates :level, presence: true
  validate :user_id_must_exist, :program_id_must_exist, :level_must_fall_within_range
  validates_uniqueness_of :user_id, :scope => :program_id

  private
    def level_must_fall_within_range
      errors.add(:level, "is not set correctly") if ((!level.nil?) && ((level < ConstantsHelper::ROLE_LEVEL_STUDENT) || (level > ConstantsHelper::ROLE_LEVEL_SUPERUSER)))
    end

    def program_id_must_exist
      program = Program.find_by_id(program_id)
      errors.add(:program_id, "must reference valid program") if program.nil?
    end

    def user_id_must_exist
      user = User.find_by_id(user_id)
      errors.add(:user_id, "must reference valid user") if user.nil?
    end
end
