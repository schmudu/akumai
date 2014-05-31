require 'spec_helper'

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
  it { should respond_to(:student_id) }

  describe "validation" do
    before do
      @program = FactoryGirl.create(:program)
      @user = FactoryGirl.create(:user)
      @role.program_id = @program.id
      @role.user_id = @user.id
    end

    describe "valid information" do
      it { should be_valid}
      it "admin account should not have a student_id" do
          @test_role = Role.create(:user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN, :student_id => nil)
          expect(@test_role).to be_valid
      end

      it "admin account should not have a student_id" do
          @test_role = Role.create(:user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF, :student_id => nil)
          expect(@test_role).to be_valid
      end
    end

    describe "invalid information" do
      describe "user id" do
        # NOTE: user_id can be valid because if an import of data references a student id, then a role
        # is created even if a user has not claimed that student id
        describe "is nil" do
          before { @role.user_id = nil}
          it { should be_valid }
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
          @first_role = Role.create(:user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => "a001")
          expect(@first_role).to be_valid
          @another_role = Role.new(:user_id => @role.user_id, :program_id => @role.program_id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => "a002")
          expect(@another_role).to_not be_valid
        end
      end

      describe "only student role should have student_id" do
        it "ensure admin doesn't have a student id" do
          @another_user = FactoryGirl.create(:user)
          @test_role = Role.new(:user_id => @another_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN, :student_id => "a0002")
          expect(@test_role).to_not be_valid
        end

        it "ensure staff doesn't have a student id" do
          @another_user = FactoryGirl.create(:user)
          @test_role = Role.new(:user_id => @another_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF, :student_id => "a0002")
          expect(@test_role).to_not be_valid
        end

        it "ensure student has a student id" do
          @another_user = FactoryGirl.create(:user)
          @test_role = Role.new(:user_id => @another_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => nil)
          expect(@test_role).to_not be_valid
        end
      end

      describe "unique student id" do
        it "should not allow duplicate student id" do
          @student_id = "b0001"
          @another_user = FactoryGirl.create(:user)
          @first_role = Role.create(:user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => @student_id)
          expect(@first_role).to be_valid
          @another_role = Role.new(:user_id => @another_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => @student_id)
          expect(@another_role).to_not be_valid
        end
      end

      describe "level" do
        describe "is nil" do
          before { @role.level = nil}
          it { should_not be_valid }
        end

        describe "should not allow level below student" do
          before { @role.level = ConstantsHelper::ROLE_LEVEL_STUDENT - 1}
          it { should_not be_valid }
        end

        describe "should not allow level above superuser" do
          before { @role.level = ConstantsHelper::ROLE_LEVEL_SUPERUSER + 1}
          it { should_not be_valid }
        end
      end
    end
  end
end
