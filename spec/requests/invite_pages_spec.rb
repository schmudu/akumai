require 'spec_helper'

require_relative '../../app/helpers/constants_helper'

def create_test_invite(user_level, invitation_id)
  invite = FactoryGirl.build(:invite)
  invite.code = "abc"
  invite.email = "abc@abc.com"
  invite.student_id = "abc01"
  invite.user_level = user_level
  invite.invitation_id = invitation_id
  invite.save
  return invite
end

def create_test_invitation(user_id, program_id, user_level)
  invitation = Invitation.new
  invitation.name = "Random Invitation"
  invitation.creator_id = user_id
  invitation.program_id = program_id
  invitation.user_level = user_level
  invitation.recipient_emails = ""
  invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
  invitation.save
  return invitation
end

describe "InvitePages" do
  before do
    @program = Program.create(:name => "Program Name") 
    @superuser = FactoryGirl.create(:user, :superuser => true)

    @password = "foobar123"
  end
  let(:superuser) { FactoryGirl.create(:user, :email => "superuser@abc.com", :superuser => true) }

  subject { page }

  describe "signup path" do
    describe "content" do
      describe "non-student invite" do
        before(:each) do 
          @invitation = create_test_invitation(@superuser.id, @program.id, ConstantsHelper::ROLE_LEVEL_STAFF)
          @invite = create_test_invite(ConstantsHelper::ROLE_LEVEL_STAFF, @invitation_id)
          visit invite_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
        end
        it { current_path.should == invite_signup_path }
        it { should have_content(@invite.code)}
        it { should have_content(@invite.email)}
      end

      describe "student invite" do
        before(:each) do 
          @invitation = create_test_invitation(@superuser.id, @program.id, ConstantsHelper::ROLE_LEVEL_STAFF)
          @invite = create_test_invite(ConstantsHelper::ROLE_LEVEL_STAFF, @invitation_id)
          visit invite_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
        end
        it { current_path.should == invite_signup_path }
        it { should have_content(@invite.code)}
        it { should have_content(@invite.email)}
        it { should have_content(I18n.t('terms.student_id'))}
      end
    end
    describe "submitting content" do
      describe "non-student invite" do
        before do
          fill_in "user_email", :with => @invite.email
          fill_in "user_password", :with => @password
          fill_in "user_password_confirmation", :with => @password
          fill_in "invite_code", :with => @invite.code
          click_button I18n.t('terms.next')
        end

        describe "valid content" do
        end

        describe "invalid content" do
        end
      end

      describe "student invite" do
        before do
          fill_in "user_email", :with => @invite.email
          fill_in "user_password", :with => @password
          fill_in "user_password_confirmation", :with => @password
          fill_in "invite_code", :with => @invite.code
          fill_in "invite_student_id", :with => @invite.student_id
        end
      end
    end
  end
end
