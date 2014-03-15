class InvitesController < ApplicationController
  before_filter :authenticate_user!, except: [:signup, :respond]
  def show
  end

  def respond
    render :text => "Congrats!"
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
end
