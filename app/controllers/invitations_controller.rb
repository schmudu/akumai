class InvitationsController < ApplicationController
  include InvitationsHelper, UsersHelper 
  before_filter :authenticate_user!
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]

  def invite
    @errors = {}
    @programs = current_user.staff_level_programs
  end

  def review_invitations
    @program_friendly = params[:program_id]
    @invitation_type = params[:invitation_type]
    @emails = params[:email_addresses]
    @errors = {}

    validation_invitation_sender = current_user.valid_invitation_sender?(@program_friendly, @invitation_type)
    validation_invitation_recipient = valid_invitation_recipients?(current_user, @emails, @program_friendly, @invitation_type)
    validation_email = valid_email_addresses?(@emails)

    if ((validation_invitation_recipient[:valid] == true) && (validation_invitation_sender[:valid] == true) && (validation_email[:valid] == true))
      @program = Program.friendly.find(@program_friendly)
      @invitation_level = user_level(@invitation_type)
      @emails = validation_email[:emails]
    else
      # error with input
      @errors = validation_invitation_sender.merge(validation_email)
      @errors = @errors.merge(validation_invitation_recipient)
      @programs = current_user.staff_level_programs
    end
  end

  def send_invitations
    render :text => "Send Invitations"
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
  end

  # GET /invitations/1/edit
  def edit
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to @invitation, notice: 'Invitation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @invitation }
      else
        format.html { render action: 'new' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params[:invitation]
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
          unless invitation.errors[:duplicate_invitation].nil?
            results[:duplicate_invitation] = {} if results[:duplicate_invitation].nil?
            results[:duplicate_invitation][email_address.parameterize.to_sym] = email_address
          end

          unless invitation.errors[:role_in_program].empty?
            results[:role_in_program] = {} if results[:role_in_program].nil?
            results[:role_in_program][email_address.parameterize.to_sym] = email_address
          end
        end
      end
       
      results[:valid] = true if ((results[:duplicate_invitation].nil?) && (results[:role_in_program].nil?))
      return results
    end
end
