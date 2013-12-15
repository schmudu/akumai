require 'spec_helper'

describe InvitationsController do
  before(:each) do
    @user=FactoryGirl.create(:user)
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
      end
    end
  end
end
