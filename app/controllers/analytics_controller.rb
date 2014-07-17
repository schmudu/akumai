class AnalyticsController < ApplicationController
  def index
    programs = current_user.staff_level_programs
    @students = Program.collect_students(programs)
    @core_courses = CoreCourse.all
  end
end
