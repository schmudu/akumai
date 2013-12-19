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
  it { should respond_to(:sent_invitations) }
  it { should respond_to(:received_invitations) }
  it { should respond_to(:staff_level_programs) }
  it { should respond_to(:staff_level_programs) }
  it { should respond_to(:valid_invitation_sender?) }

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
    describe "relationship between roles and programs" do
      subject do
        lambda do
          @program = FactoryGirl.create(:program)
          @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        end
      end

      it { should change(@user.roles, :count).from(0).to(1) }
      it { should change(@user.programs, :count).from(0).to(1) }

    end
    describe "staff level programs" do
      describe "one staff level program" do
        before do
          @program = FactoryGirl.create(:program)
          @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        end

        it "program staff_level count" do
          expect(@user.staff_level_programs.count).to eq(0)
        end
      end

      describe "one staff level program" do
        before do
          @program = FactoryGirl.create(:program)
          @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF)
        end

        it "program staff_level count" do
          expect(@user.staff_level_programs.count).to eq(1)
        end
      end
    end
  end

  describe "valid invitations?" do
    before do
      @superuser = FactoryGirl.create(:user, superuser: true)
    end

    describe "with invalid info" do
      describe "with no role in program" do
        it "sending out admin invite should return error" do
          @program = FactoryGirl.create(:program)
          result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_ADMIN)
          result[:valid].should eq(false)
          result[:invitation_level].should eq("You do not have the privileges to add users to this program.")
        end

        it "sending out admin invite should return error" do
          @program = FactoryGirl.create(:program)
          result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STAFF)
          result[:valid].should eq(false)
          result[:invitation_level].should eq("You do not have the privileges to add users to this program.")
        end

        it "sending out admin invite should return error" do
          @program = FactoryGirl.create(:program)
          result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STUDENT)
          result[:valid].should eq(false)
          result[:invitation_level].should eq("You do not have the privileges to add users to this program.")
        end
      end
    end

    describe "as a superuser" do
      it "sending out admin invite should be valid" do
        @program = FactoryGirl.create(:program)
        result=@superuser.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_ADMIN)
        result[:valid].should eq(true)
      end

      it "sending out admin invite should be valid" do
        @program = FactoryGirl.create(:program)
        result=@superuser.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STAFF)
        result[:valid].should eq(true)
      end

      it "sending out admin invite should be valid" do
        @program = FactoryGirl.create(:program)
        result=@superuser.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STUDENT)
        result[:valid].should eq(true)
      end
    end

    describe "as an admin member" do
      it "sending out superuser invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_SUPERUSER)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_superusers'))
      end

      it "sending out admin invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_ADMIN)
        result[:valid].should eq(true)
      end

      it "sending out staff invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STAFF)
        result[:valid].should eq(true)
      end

      it "sending out student invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STUDENT)
        result[:valid].should eq(true)
      end
    end

    describe "as a staff member" do
      it "sending out superuser invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_SUPERUSER)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_superusers'))
      end

      it "sending out admin invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_ADMIN)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_administrators'))
      end

      it "sending out staff invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STAFF)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_staff'))
      end

      it "sending out student invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STUDENT)
        result[:valid].should eq(true)
      end
    end

    describe "as a student member" do
      it "sending out superuser invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_SUPERUSER)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_superusers'))
      end

      it "sending out admin invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_ADMIN)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_administrators'))
      end

      it "sending out staff invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STAFF)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_staff'))
      end

      it "sending out student invite should return error" do
        @program = FactoryGirl.create(:program)
        @role = Role.create(:program_id => @program.id, :user_id => @user.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
        result=@user.valid_invitation_sender?(@program.slug, ConstantsHelper::ROLE_LEVEL_STUDENT)
        result[:valid].should eq(false)
        result[:invitation_level].should eq(I18n.t('invitations.form.errors.privileges_students'))
      end
    end
  end
end
