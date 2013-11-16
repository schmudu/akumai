require 'spec_helper'

describe "InvitationPages" do
  let(:user) { FactoryGirl.create(:user, superuser: true) }
  let(:program) { FactoryGirl.create(:program) }
  before(:each) { login user }
  subject { page }
  describe "without logging in" do
    before do   
      logout user
      visit invitations_path
    end 

    it "path should go to invite users path" do
      current_path.should == new_user_session_path
    end
  end

  describe "with logging in" do
    before do   
      visit invitations_path
    end 

    it "path should go to invite users path" do
      current_path.should == invitations_path
    end
  end
end
