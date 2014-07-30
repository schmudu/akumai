namespace :db do
  # run via: rake db:populate_core_courses
  desc "Fill database with core courses"
  task populate_core_courses: :environment do
    courses = Array.new

    # LIST OF CORE COURSES
    # Note: Only do numbers not numerals
    # Example: Instead of "Algebra II" insert "Algebra 2"
    courses = ['algebra',
                'geometry',
                'trigonometry']

    # Iterate through list and create them
    courses.each do |course|
      CoreCourse.create(:name => course)
    end
  end
end
