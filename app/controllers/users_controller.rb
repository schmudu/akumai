class UsersController < ApplicationController
  def dashboard
    @programs = build_programs
  end

  private
    def build_programs
      if current_user.superuser?
        # list all programs
        programs = Program.all.to_a.map_send(:serializable_hash, only: [:slug, :name])
        programs.map{|x| x[:level] = ConstantsHelper::ROLE_LEVEL_SUPERUSER}
      else
        # only list programs user has access to
        programs = User.joins(:roles, :programs)
            .where("users.id = ?", current_user.id)
            .select("roles.level, programs.name, programs.slug")
            .to_a.map(&:serializable_hash)
      end
      return programs
    end
end
