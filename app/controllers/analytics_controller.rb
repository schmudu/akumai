class AnalyticsController < ApplicationController
  def index
    programs = current_user.staff_level_programs
    @students = Program.collect_students(programs)
    @core_courses = CoreCourse.all
  end

  def index_helper
    programs = current_user.programs
    dataset_entries = []
    programs.each do |program|
      dataset_entries.concat(program.dataset_entries.select("data, dataset_id, date, role_id").to_a)
    end
    render json: dataset_entries
  end
end
