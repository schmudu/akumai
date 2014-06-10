class CoreCourse < ActiveRecord::Base
  include CoursesHelper
  before_validation :scrub_name

  has_many :mapped_courses, dependent: :destroy

  validates_presence_of :name
  validate :duplicate_name

  after_create :create_mapped_course
  before_save :update_mapped_courses

  private
    def create_mapped_course
      # create a mapped course each time a core course has been created
      Program.all.each do |program|
        MappedCourse.create(:program_id => program.id, :name => self.name, :core_course_id => self.id)
      end
    end

    def duplicate_name
      courses = CoreCourse.where("name = ?", self.name)
      unless courses.empty?
        errors.add(:base, I18n.t('core_course.errors.duplicate_name')) 
      end
    end

    def update_mapped_courses
      # update all mapped courses that had the previous name
      return if ((self.name == self.name_was) || (self.name_was.nil?))
      mapped_courses = MappedCourse.where("name = ?", self.name_was)
      mapped_courses.each do |course|
        course.update_attribute(:name, self.name)
      end
    end
end
