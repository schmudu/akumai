class InvitesController < ApplicationController
  before_filter :authenticate_user!, except: [:signup, :respond]
  def show
  end

  def respond_signup
    @referenced_invite = Invite.friendly.find(params[:invite_id])

    @user = User.new(invite_params_respond_user)
    @invite = Invite.new(invite_params_respond_invite)
    if params[:reject].nil? 
      # accept
      if @user.valid? && @referenced_invite.matches?(@invite, true)
        @referenced_invite.update_attribute(:status, ConstantsHelper::INVITE_STATUS_ACCEPTED)
        @user.save
        Role.create(:user_id => @user.id, 
          :program_id => @referenced_invite.program.id, 
          :level => @invite.user_level, 
          :student_id => @invite.student_id)
        sign_in @user
        flash[:notice] = I18n.t('invites.form.messages.accepted_signup')
        redirect_to dashboard_path
      else
        render :signup
      end
    else
      # reject
      if @referenced_invite.matches?(@invite, false)
        @referenced_invite.update_attribute(:status, ConstantsHelper::INVITE_STATUS_REJECTED)
        flash[:notice] = I18n.t('invites.form.messages.rejected_signup')
      else
        render :signup
      end
    end
  end

  def signup
    @user = create_signup_user_from_params
    @invite = create_signup_invite_from_params
    @referenced_invite = Invite.friendly.find(params[:id]) unless params[:id].nil?
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
      return_params[:email] = params[:user][:email]
      return_params[:student_id] = params[:invite_student_id] if @referenced_invite.is_for_student?
      return_params[:user_level] = @referenced_invite.user_level
      return return_params
    end

    def invite_params_respond_user
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
