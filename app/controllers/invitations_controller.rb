class InvitationsController < ApplicationController
  include HashHelper, InvitationsHelper, UsersHelper 
  before_filter :authenticate_user!
  before_action :set_invitation, only: [:show, :edit, :update, :destroy, :review, :confirm]

  def invite_users_type
    @errors = {}
    @programs = current_user.staff_level_programs
  end

  def invite_users_address
    if ((!session[:invite_users_program].nil?) && (!session[:invite_users_invitation_type].nil?))
      # session parameters have already been validated
      # usually thrown here as a rejection from next step
      programs = Program.where("slug=?",session[:invite_users_program]) 
      @program = programs.first unless programs.empty?
    else
      # this step needs to be validated
      program_friendly = params[:program_id]
      invitation_type = params[:invitation_type]

      # set flash so on redirect, options can be pre-populated
      flash[:invite_users_program] = params[:program_id] if (!params[:program_id].nil? && !params[:program_id].blank?)
      flash[:invite_users_invitation_type] = params[:invitation_type] if (!params[:invitation_type].nil? && !params[:invitation_type].blank?)
      errors = {}

      # validate sender
      validation_invitation_sender = current_user.valid_invitation_sender?(program_friendly, invitation_type)

      # validate program selected
      unless program_friendly.nil?
        # TODO - replace @program with session[:invite_users_program_name]
        #         that way we don't have to ping the db every time we want to pull name
        #        also add to reset session variables
        programs = Program.where("slug=?",program_friendly) 
        @program = programs.first unless programs.empty?
      end

      # if pass validation then set session and instance variables for this view
      if ((!@program.nil?) && (validation_invitation_sender[:valid] == true))
        @invitation_level = user_level(invitation_type.to_s)
        session[:invite_users_program_name] = @program.name
        session[:invite_users_program] = params[:program_id]
        session[:invite_users_invitation_type] = params[:invitation_type]
      else
        # collect errors
        errors = validation_invitation_sender
        errors[:error_program_id] = I18n.t('invitations.form.errors.program') if @program.nil?
        copy_hash(errors, flash)
        redirect_to invite_users_type_path
      end
    end
  end

  def review_invitations
    errors = {}

    # validate session variables
    if ((session[:invite_users_program].nil?) || (session[:invite_users_invitation_type].nil?))
      # send user back to step 1
      redirect_to invite_users_type_path
    end

    # validation of non-students
    if is_non_student?
      # set flash so on redirect, options can be pre-populated
      flash[:invite_users_email_addresses] = params[:email_addresses] if (!params[:email_addresses].nil? && !params[:email_addresses].blank?)

      validation_invitation_recipient = valid_invitation_recipients?(current_user, params[:email_addresses], session[:invite_users_program], session[:invite_users_invitation_type])
      validation_email = valid_email_addresses?(params[:email_addresses])

      # if pass validation then set session and instance variables for this view
      if ((validation_invitation_recipient[:valid] == true) && 
          (validation_email[:valid] == true))
        session[:invite_users_email_addresses] = params[:email_addresses]
        @emails = validation_email[:emails]
      else
        # collect errors
        errors = validation_invitation_recipient.merge(validation_email)
        copy_hash(errors, flash)
        redirect_to invite_users_address_path
      end
    else
      # validation students
    end
  end
  
  def send_invitations
    @program_friendly = params[:program_id]
    @invitation_type = params[:invitation_type]
    @emails_param = params[:email_addresses]
    @errors = {}
    @invitations = []

    validation_invitation_sender = current_user.valid_invitation_sender?(@program_friendly, @invitation_type)
    validation_invitation_recipient = valid_invitation_recipients?(current_user, @emails_param, @program_friendly, @invitation_type)
    validation_email = valid_email_addresses?(@emails_param)

    unless @program_friendly.nil?
      programs = Program.where("slug=?",@program_friendly) 
      @program = programs.first unless programs.empty?
    end
    if ((validation_invitation_recipient[:valid] == true) && (validation_invitation_sender[:valid] == true) && (validation_email[:valid] == true))
      #create invitations for all the users in validation_email[:emails]
      validation_email[:emails].each do |email_address|
        # search for the email
        emails = User.where("email = ?", email_address)

        if emails.empty?
          # new user
          # TODO - need to add student id if STUDENT
          student_id = nil
          student_id = "a0001" if @invitation_type.to_s == "0"
          invitation = Invitation.create(:sender_id => current_user.id, :recipient_email => email_address, :program_id => @program.id, :user_level => @invitation_type.to_s, :student_id => student_id)
          InvitationMailer.invitation_email_new_user(current_user.email, email_address, invitation.code, invitation.slug).deliver
        else
          # registered user
          # TODO - need to add student id if STUDENT
          student_id = nil
          student_id = "a0001" if @invitation_type.to_s == "0"
          invitation = Invitation.create(:sender_id => current_user.id, :recipient_id => emails.first.id, :program_id => @program.id, :user_level => @invitation_type.to_s, :student_id => student_id)
          InvitationMailer.invitation_email_registered_user(current_user.email, email_address, invitation.code, invitation.slug).deliver
        end
        @invitations << invitation
      end
    else
      # error with input
      @errors = validation_invitation_sender.merge(validation_email)
      @errors = @errors.merge(validation_invitation_recipient)
      @programs = current_user.staff_level_programs
    end
  end

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
      #render action: 'new' 
      render :new
    end
  end

  def review
    level_hash = {:status => ConstantsHelper::INVITATION_STATUS_SETUP_ADDRESS }
    @program = Program.find_by_id(@invitation.program_id)
    if @invitation.update(invitation_params_review.merge(level_hash))
      logger.info "===UPDATE SUCCESSFUL. #{@invitation.inspect} valid?#{@invitation.valid?} student_entries?#{@invitation.student_entries.count}"
      @emails = clean_and_split_email_address_to_a(@invitation.recipient_emails)
    else
      logger.info "===UPDATE UNSUCCESSFUL. #{@invitation.inspect}"
      ConstantsHelper::INVITATION_STUDENT_ENTRIES_DEFAULT.times { @invitation.student_entries.build } if @invitation.is_for_student?  # auto-populate entries
      render :address
    end
  end

  def confirm
    level_hash = {:status => ConstantsHelper::INVITATION_STATUS_SETUP_REVIEW }
    unless @invitation.update(invitation_params_send.merge(level_hash))
      render :review
    else
      #puts "=== recipient emails:#{@invitation.recipient_emails}"
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
      params.require(:invitation).permit(:name, :program_id, :user_level)
    end

    def invitation_params_review
      params.require(:invitation).permit(:recipient_emails, student_entries_attributes: [:email, :student_id])
    end

    def invitation_params_send
      params.require(:invitation).permit(:something)
    end

    def valid_invitation_recipients?(sender, emails, program_slug, invitation_level)
      results = Hash["valid".to_sym => false]

      # validate params
      return results if sender.nil?
      return results if ((emails.nil?) || (emails.empty?))
      return results if ((program_slug.nil?) || (program_slug.blank?))

      cleaned_emails = clean_and_split_email_address_to_a(emails)
      programs = Program.where("slug=?", program_slug)
      return results if programs.empty?
      program = programs.first

      cleaned_emails.each do |email_address|
        recipients = User.where("email = ?", email_address)

        if recipients.empty?
          invitation = Invitation.new(:program_id => program.id, :sender_id => sender.id, :recipient_id => nil, :recipient_email => email_address, :user_level => invitation_level.to_i)
        else
          invitation = Invitation.new(:program_id => program.id, :sender_id => sender.id, :recipient_id => recipients.first.id, :recipient_email => nil, :user_level => invitation_level.to_i)
        end

        unless invitation.valid?
          unless invitation.errors[:error_duplicate_invitation].empty?
            results[:error_duplicate_invitation] = {} if results[:duplicate_invitation].nil?
            results[:error_duplicate_invitation][email_address.parameterize.to_sym] = email_address
          end

          unless invitation.errors[:error_role_in_program].empty?
            results[:error_role_in_program] = {} if results[:role_in_program].nil?
            results[:error_role_in_program][email_address.parameterize.to_sym] = email_address
          end
        end
      end
       
      results[:valid] = true if ((results[:error_duplicate_invitation].nil?) && (results[:error_role_in_program].nil?))
      return results
    end
end
