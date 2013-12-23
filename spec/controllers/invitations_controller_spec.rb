require 'spec_helper'

describe InvitationsController do
  before(:each) do
    @user=FactoryGirl.create(:user, :email => "sender@abc.com")
    @another_user=FactoryGirl.create(:user, :email => "another_user@def.com")
    @user_email_not_in_program = "outside_user@gef.com"
    @program=FactoryGirl.create(:program)
    @role=FactoryGirl.create(:role, user_id:@user.id, program_id:@program.id, level:ConstantsHelper::ROLE_LEVEL_STAFF)
    sign_in @user
  end

  describe "POST 'review_invitations'" do
    before(:each) do
      @params = {}
    end

    describe "with invalid params" do
      it "without any parameters" do
        post :review_invitations, @params
        assigns[:programs].should_not be_nil
      end

      it "with only program_id" do
        @params[:program_id] = @program.slug
        post :review_invitations, @params 
        assigns[:programs].should_not be_nil
      end

      it "with only invitation_type" do
        @params[:invitation_type]="2"
        post :review_invitations, @params 
        assigns[:programs].should_not be_nil
      end

      it "with only email_address" do
        @params[:email_addresses]="abc@abc.com"
        post :review_invitations, @params 
        assigns[:programs].should_not be_nil
      end

      it "with a user that already has a role" do
        FactoryGirl.create(:role, :user_id => @another_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@another_user.email
        post :review_invitations, @params 
        assigns[:errors].should_not be_empty
      end

      it "with a user id that already has an invitation with a sent status" do
        FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => @another_user.id, :recipient_email => nil, :program_id => @program.id, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT, :status => ConstantsHelper::INVITATION_STATUS_SENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@another_user.email
        post :review_invitations, @params 
        assigns[:errors].should_not be_empty
      end

      it "with a user email that already has an invitation with a sent status" do
        FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => nil, :recipient_email => @user_email_not_in_program, :program_id => @program.id, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT, :status => ConstantsHelper::INVITATION_STATUS_SENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@user_email_not_in_program
        post :review_invitations, @params 
        assigns[:errors].should_not be_empty
      end
    end

    describe "with valid params" do
      it "should not assign programs" do
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]="abc@abc.com"
        post :review_invitations, @params 
        assigns[:programs].should be_nil
        assigns[:program].should_not be_nil
        assigns[:invitation_level].should eq("Student")
        assigns[:emails].should_not be_nil
        assigns[:errors].should be_empty
      end
    end
  end

  describe "POST 'send_invitations'" do
    before(:each) do
      @params = {}
    end

    describe "with invalid params" do
      it "without any parameters" do
        post :send_invitations, @params
        assigns[:programs].should_not be_nil
        assigns[:errors].should_not be_nil
      end

      it "with only program_id" do
        @params[:program_id] = @program.slug
        post :send_invitations, @params 
        assigns[:programs].should_not be_nil
        assigns[:errors].should_not be_nil
      end

      it "with only invitation_type" do
        @params[:invitation_type]="2"
        post :send_invitations, @params 
        assigns[:programs].should_not be_nil
        assigns[:errors].should_not be_nil
      end

      it "with only email_address" do
        @params[:email_addresses]="abc@abc.com"
        post :send_invitations, @params 
        assigns[:programs].should_not be_nil
        assigns[:errors].should_not be_nil
      end

      it "with a user that already has a role" do
        FactoryGirl.create(:role, :user_id => @another_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@another_user.email
        post :send_invitations, @params 
        assigns[:programs].should_not be_nil
        assigns[:errors].should_not be_empty
      end

      it "with a user id that already has an invitation with a sent status" do
        FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => @another_user.id, :recipient_email => nil, :program_id => @program.id, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT, :status => ConstantsHelper::INVITATION_STATUS_SENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@another_user.email
        post :send_invitations, @params 
        assigns[:programs].should_not be_nil
        assigns[:errors].should_not be_empty
      end

      it "with a user email that already has an invitation with a sent status" do
        FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => nil, :recipient_email => @user_email_not_in_program, :program_id => @program.id, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT, :status => ConstantsHelper::INVITATION_STATUS_SENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@user_email_not_in_program
        post :send_invitations, @params 
        assigns[:programs].should_not be_nil
        assigns[:errors].should_not be_empty
      end
    end

    describe "with valid params" do
      it "should not assign programs" do
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]="abc@abc.com"
        post :send_invitations, @params 
        assigns[:programs].should be_nil
        assigns[:errors].should be_empty
      end
    end
  end
end
