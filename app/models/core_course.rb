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
      self.name.gsub!(/\s+/,' ')

      # substitute multiple whitespaces
      self.name.gsub!(/([a-z]+)(\d+)/, '\1 \2')

      # lower case
      self.name = self.name.downcase

      # split and look up any common names to rule out (see COURSE_NAME_STORE)
      name_split = self.name.split(' ')
      name_split.each_with_index do |str, i|
        if (ConstantsHelper::COURSE_NAME_STORE.has_key?(str))
          name_split[i] = ConstantsHelper::COURSE_NAME_STORE[str]
        end
      end

      self.name = name_split.join(' ')
    end
end
