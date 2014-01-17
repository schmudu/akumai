require 'spec_helper'

describe InvitationsController do
  before(:each) do
    @user=FactoryGirl.create(:user, :email => "sender@abc.com")
    @another_user=FactoryGirl.create(:user, :email => "another_user@def.com")
    @user_email_not_in_program = "outside_user@gef.com"
    @program=FactoryGirl.create(:program)
    #@role=FactoryGirl.create(:role, user_id:@user.id, program_id:@program.id, level:ConstantsHelper::ROLE_LEVEL_STAFF, student_id: nil)
    @role=FactoryGirl.create(:role, :user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF, :student_id => nil)
    sign_in @user
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe "POST 'invite_users_address'" do
    before(:each) do
      @params = {}
    end

    describe "with invalid params" do
      it "without any parameters" do
        post :invite_users_address, @params
        assigns[:programs].should_not be_nil
      end

      it "with only program_id" do
        @params[:program_id] = @program.slug
        post :invite_users_address, @params 
        assigns[:programs].should_not be_nil
      end

      it "with only invitation_type" do
        @params[:invitation_type]="2"
        post :invite_users_address, @params 
        assigns[:programs].should_not be_nil
      end

=begin
      it "with only email_address" do
        @params[:email_addresses]="abc@abc.com"
        post :invite_users_address, @params 
        assigns[:programs].should_not be_nil
      end

      it "with a user that already has a role" do
        FactoryGirl.create(:role, :user_id => @another_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@another_user.email
        post :invite_users_address, @params 
        assigns[:errors].should_not be_empty
      end

      it "with a user id that already has an invitation with a sent status" do
        FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => @another_user.id, :recipient_email => nil, :program_id => @program.id, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT, :status => ConstantsHelper::INVITATION_STATUS_SENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@another_user.email
        post :invite_users_address, @params 
        assigns[:errors].should_not be_empty
      end
=end

=begin
      it "with a user email that already has an invitation with a sent status" do
        FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => nil, :recipient_email => @user_email_not_in_program, :program_id => @program.id, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT, :status => ConstantsHelper::INVITATION_STATUS_SENT)
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@user_email_not_in_program
        post :invite_users_address, @params 
        assigns[:errors].should_not be_empty
      end
=end
    end

    describe "with valid params" do
      it "should not assign programs" do
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        #@params[:email_addresses]="abc@abc.com"
        post :invite_users_address, @params 
        assigns[:programs].should be_nil
        assigns[:program].should_not be_nil
        assigns[:invitation_level].should eq("Student")
        #assigns[:emails].should_not be_nil
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

    describe "with valid params with registered user" do
      before do
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]=@another_user.email
      end

      it "should not assign programs" do
        post :send_invitations, @params 
        assigns[:programs].should be_nil
        assigns[:errors].should be_empty
      end

      it "should increase the invitations count by 1" do
        lambda{
          post :send_invitations, @params 
        }.should change(Invitation, :count).from(0).to(1)
      end

      it "should increase the emails sent by 1" do
        lambda{
          post :send_invitations, @params 
        }.should change(ActionMailer::Base.deliveries, :count).from(0).to(1)
      end

      it "should create an invitation without a recipient_email" do
        post :send_invitations, @params 
        @invitation = Invitation.first
        @invitation.recipient_email.should be_nil
        @invitation.recipient_id.should == @another_user.id
      end

      it "should create an invitation with a SENT status" do
        post :send_invitations, @params 
        @invitation = Invitation.first
        @invitation.status.should == ConstantsHelper::INVITATION_STATUS_SENT
      end

      describe "it should send an email with content including" do 
        before do
          post :send_invitations, @params 
          @email_content = {}
          @email_content[:text] = ActionMailer::Base.deliveries.last.body.parts.first.body.raw_source 
          @email_content[:html] = ActionMailer::Base.deliveries.last.body.parts.last.body.raw_source 
        end

        it "sender email" do
          @email_content[:html].should include(@user.email)
        end

        it "invitation code2" do
          @invitation = Invitation.first
          @email_content[:html].should include(@invitation.code)
        end
      end
    end

    describe "with valid params with unregistered user" do
      before do
        @params[:program_id] = @program.slug
        @params[:invitation_type]="0"
        @params[:email_addresses]="abc@abc.com"
      end

      it "should not assign programs" do
        post :send_invitations, @params 
        assigns[:programs].should be_nil
        assigns[:errors].should be_empty
      end

      it "should increase the invitations count by 1" do
        lambda{
          post :send_invitations, @params 
        }.should change(Invitation, :count).from(0).to(1)
      end

      it "should increase the emails sent by 1" do
        lambda{
          post :send_invitations, @params 
        }.should change(ActionMailer::Base.deliveries, :count).from(0).to(1)
      end

      it "should create an invitation with a SENT status" do
        post :send_invitations, @params 
        @invitation = Invitation.first
        @invitation.status.should == ConstantsHelper::INVITATION_STATUS_SENT
      end

      it "should create an invitation without a recipient_id" do
        post :send_invitations, @params 
        @invitation = Invitation.first
        @invitation.recipient_id.should be_nil
        @invitation.recipient_email.should == "abc@abc.com"
        @invitation.slug.should_not be_blank
      end

      describe "it should send an email with content including" do 
        before do
          post :send_invitations, @params 
          @email_content = {}
          @email_content[:text] = ActionMailer::Base.deliveries.last.body.parts.first.body.raw_source 
          @email_content[:html] = ActionMailer::Base.deliveries.last.body.parts.last.body.raw_source 
        end

        it "sender email" do
          @email_content[:html].should include(@user.email)
        end

        it "invitation code" do
          @invitation = Invitation.first
          @email_content[:html].should include(@invitation.code)
        end

        it "view invitation link" do
          @email_content[:html].should include(I18n.t('invitations.email.terms.view_invitation'))
        end
      end
    end
  end
end
