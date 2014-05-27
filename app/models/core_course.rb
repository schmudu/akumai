class CoreCourse < ActiveRecord::Base
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

    def scrub_name
      return if self.name.nil?
      
      # strip white spaces 
      self.name.gsub! /\s+/, ''

      # lower case
      self.name = self.name.downcase
    end
end
