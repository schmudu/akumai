require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invitation do
  before do
    @user = FactoryGirl.create(:user)
    @another_user = FactoryGirl.create(:user)
    @program = FactoryGirl.create(:program)
    @invitation = FactoryGirl.create(:invitation, :program_id => @program.id, :sender_id => @user.id, :recipient_id => @another_user.id, :recipient_email => nil)
  end

  subject { @invitation }

  it { should respond_to(:recipient_email) }
  it { should respond_to(:recipient) }
  it { should respond_to(:user_level) }

  it { should be_valid }

  describe "invalid information" do
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

    describe "user_level is more than superuser" do
      before { @invitation.user_level = ConstantsHelper::ROLE_LEVEL_SUPERUSER + 1 }
      it { should_not be_valid }
    end
  end

  describe "valid information" do
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
  end
end
