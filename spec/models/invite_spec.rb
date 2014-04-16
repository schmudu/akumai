require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invite do
  before do
    @superuser = FactoryGirl.create(:user, :superuser => true)
    @recipient = FactoryGirl.create(:user)
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
  it { should respond_to(:active?) }
  it { should respond_to(:code) }
  it { should respond_to(:email) }
  it { should respond_to(:increment_attempts) }
  it { should respond_to(:invitation_id?) }
  it { should respond_to(:matches?) }
  it { should respond_to(:resque_attempts) }
  it { should respond_to(:recipient) }
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

    describe "recipient_id" do
      describe "can be blank" do
        before do
          @invite.recipient_id = ""
        end

        it { should be_valid}
      end

      describe "can be nil" do
        before do
          @invite.recipient_id = nil
        end

        it { should be_valid}
      end

      describe "cannot eference non-existent user" do
        before do
          @invite.recipient_id = -99
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
    before do
      @invite.code = "abc"
      @invite.email = "abc@abc.com"
      @invite.student_id = "abc01"
      @invite.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
      @invite.invitation_id = @invitation.id
      @invite.save
    end

    describe "matches?" do
      before do
        @test_invite = FactoryGirl.build(:invite)
        @test_invite.code = @invite.code
        @test_invite.email = @invite.email
        @test_invite.student_id = @invite.student_id
      end

      it { expect(@invite.matches?(@test_invite)).to eq(true) }

      describe "code doesn't match should return false" do
        before do
          @test_invite.code = @invite.code + "abc"
        end
        it { expect(@invite.matches?(@test_invite)).to eq(false) }
      end

      describe "email doesn't match should return false" do
        before do
          @test_invite.email = "some@random.email"
        end
        it { expect(@invite.matches?(@test_invite)).to eq(false) }
      end

      describe "student id doesn't match should return false" do
        before do
          @test_invite.student_id = @invite.student_id + "abc"
        end
        it { expect(@invite.matches?(@test_invite, true)).to eq(false) }
      end

      describe "student id doesn't match should return false" do
        before do
          @test_invite.student_id = @invite.student_id + "abc"
        end
        it { expect(@invite.matches?(@test_invite, false)).to eq(true) }
      end

      describe "student id doesn't match for non-student should return true b/c it doesn't matter" do
        before do
          @invite.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
          @test_invite.student_id = @invite.student_id + "abc"
        end
        it { expect(@invite.matches?(@test_invite)).to eq(true) }
      end
    end

    describe "active?" do
      describe "status of created should return false" do
        before do
          @invite.status = ConstantsHelper::INVITE_STATUS_CREATED
        end
        it { expect(@invite.active?).to eq(false) }
      end

      describe "status of sent should return true" do
        before do
          @invite.status = ConstantsHelper::INVITE_STATUS_SENT
        end
        it { expect(@invite.active?).to eq(true) }
      end

      describe "status of accepted should return false" do
        before do
          @invite.status = ConstantsHelper::INVITE_STATUS_ACCEPTED
        end
        it { expect(@invite.active?).to eq(false) }
      end

      describe "status of rejected should return false" do
        before do
          @invite.status = ConstantsHelper::INVITE_STATUS_REJECTED
        end
        it { expect(@invite.active?).to eq(false) }
      end

      describe "status of expired should return false" do
        before do
          @invite.status = ConstantsHelper::INVITE_STATUS_EXPIRED
        end
        it { expect(@invite.active?).to eq(false) }
      end
    end
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
