require "spec_helper"

describe InvitationMailer do
  describe "invitation_email" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @email = InvitationMailer.invitation_email(@user) 
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      InvitationMailer.invitation_email(@user).deliver

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

    it 'should set the subject to the correct subject' do
      ActionMailer::Base.deliveries.first.subject.should == 'Here Is Your Story!'
    end

    it "should have the correct content" do
      last_delivery = ActionMailer::Base.deliveries.last.body
      expect(@email_content[:html]).to include("Hello")
      pending
    end
  end
end
