=begin
require "spec_helper"
require 'constants_helper'

describe InvitationMailer do
  describe "invitation_email" do
    before(:each) do
      @sender = FactoryGirl.create(:user)
      @user = FactoryGirl.create(:user)
      @program = FactoryGirl.create(:program)
      @invitation = FactoryGirl.create(:invitation, :program_id => @program.id, :creator_id => @sender.id)
      @email = InvitationMailer.invitation_email_new_user(@sender.email, @user.email, @invitation.code, @invitation.slug) 
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @email.deliver

      # define email content
      @email_content = {}
      @email_content[:text] = ActionMailer::Base.deliveries.last.body.parts.first.body.raw_source 
      @email_content[:html] = ActionMailer::Base.deliveries.last.body.parts.last.body.raw_source 
    end

    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    it 'should send an email' do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it 'renders the receiver email' do
      ActionMailer::Base.deliveries.first.to.to_a.first.should == @user.email
    end

    it 'renders the sender email' do
      ActionMailer::Base.deliveries.first.from.to_a.first.should == ConstantsHelper::INVITATION_SENDER_EMAIL
    end

    it 'should set the subject to the correct subject' do
      ActionMailer::Base.deliveries.first.subject.should == I18n.t('invitations.email.title.invitation')
    end

    it "should have the correct content" do
      expect(@email_content[:html]).to include("invitation")
      pending
    end

    it "should include sender" do
      expect(@email_content[:html]).to include(@sender.email)
      pending
    end
  end
end
=end
