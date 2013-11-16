require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invitation do
  before do
    @user = FactoryGirl.create(:user)
    @another_user = FactoryGirl.create(:user)
    @invitation = FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => @another_user.id, :email => nil)
  end

  subject { @invitation }

  it { should respond_to(:email) }

  it { should be_valid }

  describe "invalid information" do
    describe "user id is not set" do
      before { @invitation.sender_id = nil }
      it { should_not be_valid }
    end

    describe "recipient id and email is not set" do
      before do 
        @invitation.recipient_id = nil
        @invitation.email = nil
      end 
      it { should_not be_valid }
    end

    describe "recipient id and email is blank" do
      before do 
        @invitation.recipient_id = ""
        @invitation.email = nil
      end 
      it { should_not be_valid }
    end

    describe "recipient id and email are both set" do
      before do 
        @invitation.recipient_id = @another_user.id 
        @invitation.email = "abc@abc.com"
      end 
      it { should_not be_valid }
    end
  end

  describe "valid information" do
    describe "should be valid with only email" do
      before do 
        @invitation.recipient_id = nil
        @invitation.email = "abc@abc.com" 
      end
      it { should be_valid }
    end

    describe "should be valid with only recipient id" do
      before do 
        @invitation.recipient_id = @another_user.id
        @invitation.email = nil
      end
      it { should be_valid }
    end
  end
end
