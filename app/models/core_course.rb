class CoreCourse < ActiveRecord::Base
  include CoursesHelper
  before_validation :scrub_name
  validates_presence_of :name
  validate :duplicate_name

  after_create :create_mapped_course

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
end
