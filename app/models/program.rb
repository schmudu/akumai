class Program < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  after_create :create_mapped_courses

  has_many :custom_errors, dependent: :destroy
  has_many :datasets, dependent: :destroy
  has_many :dataset_entries, through: :datasets, dependent: :destroy
  has_many :invites, through: :invitations
  has_many :invitations, dependent: :destroy
  has_many :mapped_courses, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :users, through: :roles

  validates :name, presence: true
  validates :name, :format => { with: /\A[a-zA-Z0-9\s\_\'\&\(\)\:]+\z/, message: "only letters, numbers, spaces, and special characters '&():"}

  def students
    self.roles.where("level = ?", ConstantsHelper::ROLE_LEVEL_STUDENT)
  end

  def self.collect_students programs
    # collects all the students of programs into an array
    students = []
    programs.each do |program|
      students.concat(program.students.order("student_id ASC").select(:student_id, :id).to_a)
    end
    return students
  end

  private
    def create_mapped_courses
      # upon creation of program, create mapped courses that already exist in list of core courses
      CoreCourse.all.each do |course|
        MappedCourse.create(:core_course_id => course.id, :name => course.name, :program_id => self.id)
      end
    end
end
