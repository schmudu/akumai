require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Role do
  before do
    @user = FactoryGirl.create(:user)
    @program = FactoryGirl.create(:program)
    @role = FactoryGirl.create(:role, :user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
  end

  subject { @role }

  it { should respond_to(:user_id) }
  it { should respond_to(:program_id) }
  it { should respond_to(:level) }

  describe "validation" do
    before do
      @program = FactoryGirl.create(:program)
      @user = FactoryGirl.create(:user)
      @role.program_id = @program.id
      @role.user_id = @user.id
    end

    describe "valid information" do
      it { should be_valid}
    end

    describe "invalid information" do
      describe "user id" do
        describe "is nil" do
          before { @role.user_id = nil}
          it { should_not be_valid }
        end

        describe "does not reference valid user" do
          before { @role.user_id = -99}
          it { should_not be_valid }
        end
      end

      describe "program id" do
        describe "is nil" do
          before { @role.program_id = nil}
          it { should_not be_valid }
        end

        describe "does not reference valid program" do
          before { @role.program_id = -99}
          it { should_not be_valid }
        end
      end

      describe "unique program and user id" do
        it "should not allow duplicate program and user id" do
          @first_role = Role.create(:user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
          expect(@first_role).to be_valid
          @another_role = Role.new(:user_id => @role.user_id, :program_id => @role.program_id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
          expect(@another_role).to_not be_valid
        end
      end

      describe "level" do
        describe "is nil" do
          before { @role.level = nil}
          it { should_not be_valid }
        end
      end
    end
  end
end
