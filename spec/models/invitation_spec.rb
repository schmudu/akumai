require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invitation do
  before do
=begin
    @another_user = FactoryGirl.create(:user, :email => "another_user@abc.com")
    @invitation = FactoryGirl.create(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => @another_user.id, :recipient_email => nil)
=end
    @superuser = FactoryGirl.create(:user, :superuser => true)
    @staff_in_program = FactoryGirl.create(:user, :email => "staff_in_program@example.com")
    @student_in_program = FactoryGirl.create(:user, :email => "student_in_program@example.com")
    @admin_in_program = FactoryGirl.create(:user, :email => "admin_in_program@example.com")
    @user_outside_of_program = FactoryGirl.create(:user, :email => "user_outside@abc.com")
    @program = FactoryGirl.create(:program)
    @role_admin = FactoryGirl.create(:role, :user_id => @admin_in_program.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN, :student_id => nil)
    @role_staff = FactoryGirl.create(:role, :user_id => @staff_in_program.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF, :student_id => nil)
    @role_student = FactoryGirl.create(:role, :user_id => @student_in_program.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)
    @invitation = Invitation.new
  end

  subject { @invitation }

  # mass-assignment

  # attributes
  it { should respond_to(:creator) }
  it { should respond_to(:creator_id) }
  it { should respond_to(:program_id) }
  it { should respond_to(:status) }
  it { should respond_to(:user_level) }
  it { should respond_to(:recipient_emails) }
  it { should respond_to(:slug) }

  describe "validation at type stage" do
    describe "valid attributes" do
      before do
        @invitation.creator_id = @staff_in_program.id
        @invitation.program_id = @program.id
        @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
        @invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
      end

      it { should be_valid }

      describe "creator id" do

        describe "set to staff inviting students" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
            @invitation.creator_id = @staff_in_program.id 
          end
          it { should be_valid }
        end

        describe "set to admin inviting students" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
            @invitation.creator_id = @admin_in_program.id 
          end
          it { should be_valid }
        end

        describe "set to admin inviting staff" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
            @invitation.creator_id = @admin_in_program.id 
          end
          it { should be_valid }
        end

        describe "set to admin inviting admin" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN
            @invitation.creator_id = @admin_in_program.id 
          end
          it { should be_valid }
        end

        describe "set to superuser inviting students" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
            @invitation.creator_id = @superuser.id 
          end
          it { should be_valid }
        end

        describe "set to superuser inviting staff" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
            @invitation.creator_id = @superuser.id 
          end
          it { should be_valid }
        end

        describe "set to superuser inviting admin" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN
            @invitation.creator_id = @superuser.id 
          end
          it { should be_valid }
        end
      end
    end

    describe "invalid attributes" do
      before do
        @invitation.creator_id = @staff_in_program.id
        @invitation.program_id = @program.id
        @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
        @invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
      end

      it { should be_valid }

      describe "creator_id" do
        describe "set to nil" do
          before { @invitation.creator_id = nil }
          it { should_not be_valid }
        end

        describe "set to non-existent user id" do
          before { @invitation.creator_id = -99 }
          it { should_not be_valid }
        end

        describe "set to student user who does not have privileges to invite other users" do
          before { @invitation.creator_id = @student_in_program.id }
          it { should_not be_valid }
        end

        describe "set to none user inviting students" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
            @invitation.creator_id = @user_outside_of_program.id 
          end
          it { should_not be_valid }
        end
        
        describe "set to none user inviting staff" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
            @invitation.creator_id = @user_outside_of_program.id 
          end
          it { should_not be_valid }
        end
        
        describe "set to none user inviting admin" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN
            @invitation.creator_id = @user_outside_of_program.id 
          end
          it { should_not be_valid }
        end

        describe "set to staff inviting staff" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
            @invitation.creator_id = @student_in_program.id 
          end
          it { should_not be_valid }
        end

        describe "set to staff inviting admin" do
          before do 
            @invitation.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN
            @invitation.creator_id = @student_in_program.id 
          end
          it { should_not be_valid }
        end
      end

      describe "program_id" do
        describe "program_id set to nil" do
          before do 
            @invitation.program_id = nil
          end
          it { should_not be_valid }
        end

        describe "program_id set to non-existent program" do
          before do 
            @invitation.program_id = -99
          end
          it { should_not be_valid }
        end
      end
    end
  end

  describe "at address stage" do
  end
=begin
  it { should respond_to(:recipient_email) }
  it { should respond_to(:recipient_id) }
  it { should respond_to(:recipient) }
  it { should respond_to(:code) }

  it { should be_valid }
  its(:status) { should eq(0) }

  describe "invalid information" do
    describe "student_id is not set and level is student" do
      before do
        @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
        @invitation.student_id = nil
      end
      it { should_not be_valid }
    end

    describe "student_id is set and level is admin" do
      before do
        @invitation.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN
        @invitation.student_id = "A001"
      end
      it { should_not be_valid }
    end

    describe "student_id is set and level is staff" do
      before do
        @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
        @invitation.student_id = "A001"
      end
      it { should_not be_valid }
    end

    describe "program id is not set" do
      before { @invitation.program_id = nil }
      it { should_not be_valid }
    end

    describe "non-existent program id" do
      before { @invitation.program_id = -99 }
      it { should_not be_valid }
    end

    describe "user id is not set" do
      before { @invitation.sender_id = nil }
      it { should_not be_valid }
    end

    describe "recipient id and email is not set" do
      before do 
        @invitation.recipient_id = nil
        @invitation.recipient_email = nil
      end 
      it { should_not be_valid }
    end

    describe "recipient id and reipient_email is blank" do
      before do 
        @invitation.recipient_id = ""
        @invitation.recipient_email = nil
      end 
      it { should_not be_valid }
    end

    describe "recipient id and reipient_email are both set" do
      before do 
        @invitation.recipient_id = @another_user.id 
        @invitation.recipient_email = "abc@abc.com"
      end 
      it { should_not be_valid }
    end

    describe "user_level is not set" do
      before { @invitation.user_level = nil }
      it { should_not be_valid }
    end

    describe "user_level is less than student" do
      before { @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT - 1 }
      it { should_not be_valid }
    end

    describe "user_level is more than admin" do
      before { @invitation.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN + 1 }
      it { should_not be_valid }
    end

    it "should not be valid if the program and the user id are the same for the second invitation and the status is SENT" do
      @first_invitation = FactoryGirl.create(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => @another_user.id, :recipient_email => nil, :status => ConstantsHelper::INVITATION_STATUS_SENT)
      @second_invitation = FactoryGirl.build(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => @another_user.id, :recipient_email => nil)
      @second_invitation.should_not be_valid
    end

    it "should not be valid if the program and the user email are the same for the second invitation and the status is SENT" do
      @first_invitation = FactoryGirl.create(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => nil, :recipient_email => @another_user.email, :status => ConstantsHelper::INVITATION_STATUS_SENT)
      @second_invitation = FactoryGirl.build(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => nil, :recipient_email => @another_user.email)
      @second_invitation.should_not be_valid
    end

    it "should not be valid if the user already has a role in the program by email" do
      @invitation = FactoryGirl.build(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => nil, :recipient_email => @user_in_program.email)
      @invitation.should_not be_valid
    end

    it "should not be valid if the user already has a role in the program by id" do
      @invitation = FactoryGirl.build(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => @user_in_program.id, :recipient_email => nil)
      @invitation.should_not be_valid
    end
  end

  describe "valid information" do
    it "code should not be nil" do
      expect(@invitation.code).not_to eq(nil)
    end

    describe "should be valid with only recipient_email" do
      before do 
        @invitation.recipient_id = nil
        @invitation.recipient_email = "abc@abc.com" 
      end
      it { should be_valid }
    end

    describe "should be valid ith only recipient id" do
      before do 
        @invitation.recipient_id = @another_user.id
        @invitation.recipient_email = nil
      end
      it { should be_valid }
    end

    describe "student_id" do
      describe "should be set if level is student" do
        before do
          @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
          @invitation.student_id = "a001"
        end
        it { should be_valid }
      end

      describe "student_id should not be set if level is staff" do
        before do
          @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
          @invitation.student_id = nil
        end
        it { should be_valid }
      end

      describe "student_id should not be set if level is admin" do
        before do
          @invitation.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN
          @invitation.student_id = nil
        end
        it { should be_valid }
      end
    end
  end
=end
end
