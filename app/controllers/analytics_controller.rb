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
      results = Role.joins(:dataset_entries)
          .joins("LEFT JOIN mapped_courses ON mapped_courses.id = dataset_entries.mapped_course_id")
          .where("mapped_courses.program_id=?", program.id)
          .select("dataset_entries.data as data, 
                    dataset_entries.date as datestring, 
                    dataset_entries.id as id, 
                    mapped_courses.name as course_name,
                    roles.student_id as student_id")  
      dataset_entries.concat(results.to_a)
    end
    render json: dataset_entries
  end
end
