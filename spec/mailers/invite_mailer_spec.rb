require "spec_helper"
require_relative '../../app/helpers/constants_helper'

describe InviteMailer do
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
    @invite.code = "abc"
    @invite.email = "abc@abc.com"
    @invite.student_id = "abc01"
    @invite.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
    @invite.invitation_id = @invitation.id
    @invite.save
  end

  describe "status after deliver should be SENT" do
    before do
      InviteMailer.send_user_unregistered(@invite).deliver
    end

    it { expect(@invite.status).to eq(ConstantsHelper::INVITE_STATUS_SENT) }
  end
end
