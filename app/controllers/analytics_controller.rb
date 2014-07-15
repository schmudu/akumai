class AnalyticsController < ApplicationController
  def index
    # TODO: way to refactor this
    programs = current_user.staff_level_programs
    @students = []
    programs.each do |program|
      @students.concat(program.students.to_a)
    end
  end
end
