class CoreCourse < ActiveRecord::Base
  include CoursesHelper
  before_validation :scrub_name
  validates_presence_of :name
  validate :duplicate_name

  private
    def duplicate_name
      courses = CoreCourse.where("name = ?", self.name)
      unless courses.empty?
        errors.add(:base, I18n.t('core_course.errors.duplicate_name')) 
      end
    end
end
