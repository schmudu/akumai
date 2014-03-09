class InvitationsController < ApplicationController
  include HashHelper, InvitationsHelper, UsersHelper 
  before_filter :authenticate_user!
  before_action :set_invitation, only: [:show, :edit, :update, :destroy, :review, :confirm]

  # GET /invitations
  # GET /invitations.json
  def index
    @invitations = Invitation.all
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
    @programs = current_user.staff_level_programs
  end

  # POST /invitations/address
  def address
    creator_hash = {:creator_id => current_user.id }
    @invitation = Invitation.new(invitation_params_address.merge(creator_hash))

    if @invitation.save
      @program = Program.find_by_id(@invitation.program_id)
      ConstantsHelper::INVITATION_STUDENT_ENTRIES_DEFAULT.times { @invitation.student_entries.build } if @invitation.is_for_student?  # auto-populate entries
    else
      @programs = current_user.staff_level_programs
      render :new
    end
  end

  def review
    #validate_student_entries_attributes_for_review_stage if @invitation.is_for_student?
    level_hash = {:status => ConstantsHelper::INVITATION_STATUS_SETUP_ADDRESS }
    @program = Program.find_by_id(@invitation.program_id)
    if @invitation.update(invitation_params_review.merge(level_hash))
      @emails = clean_and_split_email_address_to_a(@invitation.recipient_emails) if !@invitation.is_for_student?
    else
      ConstantsHelper::INVITATION_STUDENT_ENTRIES_DEFAULT.times { @invitation.student_entries.build } if @invitation.is_for_student?  # auto-populate entries
      render :address
    end
  end

  def confirm
    if @invitation.has_invites?
      flash[:notice] = I18n.t('invitations.form.errors.invites_already_created')
    else
      level_hash = {:status => ConstantsHelper::INVITATION_STATUS_SETUP_REVIEW}
      unless @invitation.update(level_hash)
        render :review
      else
        flash[:notice] = I18n.t('invitations.form.messages.invites_sent')
        @invitation.create_invites
      end
    end
  end

  # GET /invitations/1/edit
  def edit
  end

  # PATCH/PUT /invitations/1
  # PATCH/PUT /invitations/1.json
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to @invitation, notice: 'Invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_url }
      format.json { head :no_content }
    end
  end

  def cancel
    #redirect_to dashboard_path
    respond_to do |format|
      msg = { :text => "success" }
      format.json { render :json => msg }
    end
  end

  private
    def remove_default_params_review
      if @invitation.is_for_student?
        params[:invitation][:student_entries_attributes].each do |key, attr|
          attr[:email] = "" if attr[:email] == ConstantsHelper::INVITATION_DEFAULT_STUDENT_EMAIL
          attr[:student_id] = "" if attr[:student_id] == ConstantsHelper::INVITATION_DEFAULT_STUDENT_ID
        end
      else
        #attr[:student_id] = "" if attr[:student_id] == ConstantsHelper::INVITATION_DEFAULT_STUDENT_ID
      end
    end

    def is_non_student?
      return true if ((session[:invite_users_invitation_type].to_i == ConstantsHelper::ROLE_LEVEL_ADMIN) ||
        (session[:invite_users_invitation_type].to_i == ConstantsHelper::ROLE_LEVEL_STAFF))
      return false
    end
    
    def set_invitation
      @invitation = Invitation.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params_address
      params.require(:invitation).permit(:name, :program_id, :user_level, :status)
    end

    def invitation_params_review
      remove_default_params_review
      validate_student_entries_attributes_for_review_stage if @invitation.is_for_student?
      params.require(:invitation).permit(:recipient_emails, :status, student_entries_attributes: [:invitation_id, :email, :student_id])
    end

    def validate_student_entries_attributes_for_review_stage
      # iterate through student attributes if none of them are set then add error
      params[:invitation][:student_entries_attributes].each do |key, attr|
        return if (!attr[:email].blank? && !attr[:student_id].blank?)
      end
      @invitation.errors.add(:student_entries_attributes, "something is wrong") 
    end
end
