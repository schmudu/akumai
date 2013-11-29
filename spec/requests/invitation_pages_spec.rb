require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe "InvitationPages" do
  let(:user) { FactoryGirl.create(:user, superuser: true) }
  let(:program) { FactoryGirl.create(:program, name:"Program_Name") }
  before(:each) { login user }
  subject { page }
  describe "without logging in" do
    before do   
      logout user
      visit invite_users_path
    end 

    it "path should go to invite users path" do
      current_path.should == new_user_session_path
    end
  end

  describe "with logging in" do
    before do   
      FactoryGirl.create(:role, user_id:user.id, program_id:program.id, level:ConstantsHelper::ROLE_LEVEL_SUPERUSER)
      visit invite_users_path
    end 

    it "path should go to invite users path" do
      current_path.should == invite_users_path
    end

    describe "should have appropriate controls" do
      it { should have_selector("label", :text => "Program") }
      it { should have_selector("label", :text => "Student") }
      it { should have_selector("option", :text => "Program_Name") }
    end
  end
end
