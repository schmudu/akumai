class InvitesController < ApplicationController
  before_filter :authenticate_user!, except: [:signup, :respond]
  def show
  end

  def respond_signup
=begin
    @referenced_invite = Invite.friendly.find(params[:invite_id])
    @user = User.new(invite_params_respond_user)
    @invite = Invite.new(invite_params_respond_invite)
=end
=begin
    if @invite.matches(@real_invite) do
    else
      render :signup
    end
=end
    render :text => "=== parmas:#{params.inspect}"
  end

  def signup
    @user = create_signup_user_from_params
    @invite = create_signup_invite_from_params
    @real_invite = Invite.friendly.find(params[:id]) unless params[:id].nil?
  end

  private
    def create_signup_invite_from_params
      invite = Invite.new
      invite.code = params[:code]
      return invite
    end

    def create_signup_user_from_params
      user = User.new
      temp_email = params[:email].html_safe

      # TODO - validate email regex

      user.email = temp_email
      return user
    end

    def invite_params_respond_invite
      # TODO - need to extract params that are specific to invites
      # is there a better way of doing this?
      return_params = {}
      return_params[:code] = params[:invite_code]
      return_params[:student_id] = params[:invite_student_id] if @referenced_invite.is_for_student?
      return_params[:user_level] = @referenced_invite.user_level
      return return_params
    end

    def invite_params_respond_user
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
