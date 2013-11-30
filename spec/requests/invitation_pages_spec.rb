require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe "InvitationPages" do
  let(:user) { FactoryGirl.create(:user, superuser: false) }
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
    let (:program_admin) { FactoryGirl.create(:program, name:"Program_Admin")}
    let (:program_staff) { FactoryGirl.create(:program, name:"Program_Staff")}
    let (:program_student) { FactoryGirl.create(:program, name:"Program_Student")}

    before do   
      FactoryGirl.create(:role, user_id:user.id, program_id:program_admin.id, level:ConstantsHelper::ROLE_LEVEL_ADMIN)
      FactoryGirl.create(:role, user_id:user.id, program_id:program_staff.id, level:ConstantsHelper::ROLE_LEVEL_STAFF)
      FactoryGirl.create(:role, user_id:user.id, program_id:program_student.id, level:ConstantsHelper::ROLE_LEVEL_STUDENT)
      visit invite_users_path
    end 

    it "path should go to invite users path" do
      current_path.should == invite_users_path
    end

    describe "should have appropriate controls" do
      it { should have_selector("label", :text => "Program") }
      it { should have_selector("label", :text => "Student") }
      it { should have_selector("option", :text => "Program_Admin") }
      it { should have_selector("option", :text => "Program_Staff") }
      it { should_not have_selector("option", :text => "Program_Student") }
    end

    describe "superuser should have all programs" do
      let(:superuser) { FactoryGirl.create(:user, superuser: true) }
      subject { page }

      before do
        logout user
        login superuser
        visit invite_users_path
      end

      describe "should have appropriate controls" do
        it { should have_selector("option", :text => "Program_Admin") }
        it { should have_selector("option", :text => "Program_Staff") }
        it { should have_selector("option", :text => "Program_Student") }
      end
    end
  end
end
