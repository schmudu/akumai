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
      results = MappedCourse.joins(:dataset_entries)
          .where("mapped_courses.program_id=?", program.id)
          .select("dataset_entries.data as data, 
                    dataset_entries.created_at as date, 
                    dataset_entries.id as id, 
                    mapped_courses.name as course_name")  
      #dataset_entries.concat(program.dataset_entries.select("data, dataset_id, date, role_id").to_a)
      dataset_entries.concat(results.to_a)

=begin
results = MappedCourse.joins(:dataset_entries)
    .where("mapped_courses.program_id=?", 2)
    .select("dataset_entries.data as data, 
              dataset_entries.created_at as date, 
              dataset_entries.id as id, 
              mapped_courses.name as course_name")  
=end
    end
    render json: dataset_entries
  end
end
