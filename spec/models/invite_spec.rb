require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invite do
  before do
    @superuser = FactoryGirl.create(:user, :superuser => true)
    @program = FactoryGirl.create(:program)
    @invitation = Invitation.new
    @invitation.name = "Random Invitation"
    @invitation.creator_id = @superuser.id
    @invitation.program_id = @program.id
    @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
    @invitation.recipient_emails = ""
    @invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
    @invitation.save
    @invite = FactoryGirl.build(:invite)
  end

  subject { @invite }

  # attributes
  it { should respond_to(:matches) }
  it { should respond_to(:code) }
  it { should respond_to(:email) }
  it { should respond_to(:student_id) }
  it { should respond_to(:user_level?) }
  it { should respond_to(:invitation_id?) }
  it { should respond_to(:resque_attempts) }
  it { should respond_to(:increment_attempts) }

  describe "attributes" do
    before do
      @invite.code = "abc"
      @invite.email = "abc@abc.com"
      @invite.student_id = "abc01"
      @invite.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
      @invite.invitation_id = @invitation.id
    end

    it { should be_valid }

    describe "code" do
      describe "should not be blank after save" do
        before do
          @invite.code = ""
          @invite.save
        end

        its(:code) { should_not be_nil }
        its(:code) { should_not be_blank }
      end

      describe "should not re-populate after another save" do
        before do
          @invite.save
          @code_first = @invite.code
          @invite.save
        end

        its(:code) { should == @code_first }
      end
    end

    describe "email" do
      describe "should not be blank" do
        before do
          @invite.email = ""
        end

        it { should_not be_valid}
      end

      describe "should not be nil" do
        before do
          @invite.email = nil
        end

        it { should_not be_valid}
      end

      describe "should not be invalid email" do
        before do
          @invite.email = "asdfasd.com"
        end

        it { should_not be_valid}
      end
    end

    describe "invitation_id" do
      describe "should not be blank" do
        before do
          @invite.invitation_id = ""
        end

        it { should_not be_valid}
      end

      describe "should not be nil" do
        before do
          @invite.invitation_id = nil
        end

        it { should_not be_valid}
      end

      describe "should not reference non-existent invitation" do
        before do
          @invite.invitation_id = -99
        end

        it { should_not be_valid}
      end
    end

    describe "user_level" do
      describe "should not be blank" do
        before do
          @invite.user_level = ""
        end

        it { should_not be_valid}
      end

      describe "should not be nil" do
        before do
          @invite.user_level = nil
        end

        it { should_not be_valid}
      end

      describe "should not be set to superuser" do
        before do
          @invite.user_level = ConstantsHelper::ROLE_LEVEL_SUPERUSER
        end

        it { should_not be_valid}
      end
    end

    describe "student_id" do
      describe "admin user level" do
        before do
          @invite.user_level = ConstantsHelper::ROLE_LEVEL_ADMIN
        end

        describe "should not be blank" do
          before do
            @invite.student_id = ""
          end

          it { should be_valid}
        end

        describe "should not be nil" do
          before do
            @invite.student_id = nil
          end

          it { should be_valid}
        end
      end

      describe "staff user level" do
        before do
          @invite.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
        end

        describe "should not be blank" do
          before do
            @invite.student_id = ""
          end

          it { should be_valid}
        end

        describe "should not be nil" do
          before do
            @invite.student_id = nil
          end

          it { should be_valid}
        end
      end

      describe "student user level" do
        before do
          @invite.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
        end

        describe "should not be blank" do
          before do
            @invite.student_id = ""
          end

          it { should_not be_valid}
        end

        describe "should not be nil" do
          before do
            @invite.student_id = nil
          end

          it { should_not be_valid}
        end
      end
    end
  end

  describe "instance methods" do
    pending "need to have method that verifies that two invites match"
  end

  describe "delayed jobs creation" do
    before do
      ResqueSpec.reset!
      @invite.code = "abc"
      @invite.email = "abc@abc.com"
      @invite.student_id = "abc01"
      @invite.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
      @invite.invitation_id = @invitation.id
    end

    it "queues mail when a contact is created" do
      @invite.save
      MailInviteUserUnregisteredJob.should have_queued(@invite.id).in(:mail)
    end
  end
end
