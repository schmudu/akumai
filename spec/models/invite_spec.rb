require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invite do
  before do
    @admin_in_program = FactoryGirl.create(:user, :email => "admin_in_program@example.com")
    @program = FactoryGirl.create(:program)
    @invitation = FactoryGirl.build(:invitation)
    @invitation.name = "Random Invitation"
    @invitation.creator_id = @admin_in_program.id
    @invitation.program_id = @program.id
    @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
    @invitation.recipient_emails = "abc@abc.com"
    @invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
    @invitation.save
    @invite = FactoryGirl.build(:invite)
  end

  subject { @invite }

  # attributes
  it { should respond_to(:code) }
  it { should respond_to(:email) }
  it { should respond_to(:student_id) }
  it { should respond_to(:user_level?) }

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
      describe "should not be blank" do
        before do
          @invite.code = ""
        end

        it { should_not be_valid}
      end

      describe "should not be nil" do
        before do
          @invite.code = nil
        end

        it { should_not be_valid}
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
end
