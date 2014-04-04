class UsersController < ApplicationController
  def dashboard
    @programs = current_user.staff_level_programs
  end
end
