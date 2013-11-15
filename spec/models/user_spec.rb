require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:superuser) }
  it { should respond_to(:roles) }
  it { should respond_to(:programs) }

  # user types
  it { should respond_to(:is_superuser?) }

  describe "after creation should be student by default" do
    its(:is_superuser?) { should eq(false) }
  end

  describe "set superuser to true" do
    before do 
      @user.superuser = true 
      @user.save
    end
    its(:is_superuser?) { should eq(true) }
  end

  describe "roles and programs" do
    subject do
      lambda do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
      end
    end

    it { should change(@user.roles, :count).from(0).to(1) }
    it { should change(@user.programs, :count).from(0).to(1) }
  end
end
