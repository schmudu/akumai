require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invitation do
  before do
    @user = FactoryGirl.create(:user)
    @invitation = FactoryGirl.create(:invitation, :user_id => @user.id)
  end

  subject { @invitation }

  it { should respond_to(:email) }
  it { should respond_to(:recipient) }

  it { should be_valid }

  describe "invalid information" do
    describe "user id is not set" do
      before { @invitation.user_id = nil }
      it { should_not be_valid }
    end

    describe "email is not set and recipient is not set" do
      before do 
        @invitation.email = nil
      end 
      it { should_not be_valid }
    end
  end

  describe "valid information" do
    describe "with a recipient" do
      before do
        @recipient = FactoryGirl.create(:user)
        @recipient.invitation_recipient_id = @invitation.id
      end 
      
      it { should be_valid }
    end

    describe "with an email" do
      before { @invitation.email = "abc@abc.com" }
      
      it { should be_valid }
    end
  end
end
