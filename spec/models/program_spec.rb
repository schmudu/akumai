require 'spec_helper'

describe Program do
  before do
    @program = FactoryGirl.create(:program) 
  end

  subject { @program }

  it { should respond_to(:datasets) }
  it { should respond_to(:name) }
  it { should respond_to(:users) }
  it { should respond_to(:roles) }
  it { should respond_to(:invitations) }

  it { should be_valid }

  describe "relationships" do
    before do
      @user = FactoryGirl.create(:user)
      @superuser = FactoryGirl.create(:user, :superuser => true)
      @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => "a0002")
      @invitation = FactoryGirl.create(:invitation, :name => "Test Invitation", :creator_id => @superuser.id, :program_id => @program.id, :status => ConstantsHelper::INVITATION_STATUS_SETUP_TYPE, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT)
    end

    it { Role.count.should == 1 }
    it {Invitation.count.should == 1 }

    it "should decrement the roles count by -1" do
      expect{@program.destroy}.to change{Role.count}.by(-1)
    end

    it "should decrement the invitations count by -1" do
      expect{@program.destroy}.to change{Invitation.count}.by(-1)
    end
  end

  describe "name validations" do
    describe "should not be valid with empty name" do
      before { @program.name = "" }
      it { should_not be_valid }
    end

    describe "should not be valid with blank name" do
      before { @program.name = " " }
      it { should_not be_valid }
    end

    describe "should be valid with underline" do
      before { @program.name = "_ABC123456" }
      it { should be_valid }
    end

    describe "should be valid with lower and uppercase letters and numbers" do
      before { @program.name = "abcDEF123" }
      it { should be_valid }
    end

    describe "should be valid with quotation mark" do
      before { @program.name = "Patrick's Program" }
      it { should be_valid }
    end

    describe "should be valid with and symbol" do
      before { @program.name = "Mary & William" }
      it { should be_valid }
    end

    describe "should be valid with parenthesis" do
      before { @program.name = "UC (San Diego)" }
      it { should be_valid }
    end

    describe "should be valid with colon" do
      before { @program.name = "UC :: San Diego" }
      it { should be_valid }
    end

    describe "should not be valid with exclamation point" do
      before { @program.name = "!ABC123456" }
      it { should_not be_valid }
    end

    describe "should not be valid with at symbol" do
      before { @program.name = "@ABC123456" }
      it { should_not be_valid }
    end

    describe "should not be valid with dollar symbol" do
      before { @program.name = "$ABC123456" }
      it { should_not be_valid }
    end

    describe "should not be valid with percent sign" do
      before { @program.name = "%ABC123456" }
      it { should_not be_valid }
    end

    describe "should not be valid with carat symbol" do
      before { @program.name = "^ABC123456" }
      it { should_not be_valid }
    end

    describe "should not be valid with star symbol" do
      before { @program.name = "*ABC123456" }
      it { should_not be_valid }
    end
  end

  describe "roles and programs" do
    subject do
      lambda do
        @user = FactoryGirl.create(:user)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => "a0002")
      end
    end

    it { should change(@program.roles, :count).from(0).to(1) }
    it { should change(@program.users, :count).from(0).to(1) }
  end

end
