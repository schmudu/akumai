require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invitation do
  before do
    @user = FactoryGirl.create(:user)
    @another_user = FactoryGirl.create(:user)
    @invitation = FactoryGirl.create(:invitation, :sender_id => @user.id, :recipient_id => @another_user.id)
  end

  subject { @invitation }

  it { should respond_to(:email) }

  it { should be_valid }

  describe "invalid information" do
    describe "user id is not set" do
      before { @invitation.sender_id = nil }
      it { should_not be_valid }
    end

    describe "user id is not set" do
      before { @invitation.recipient_id = nil }
      it { should_not be_valid }
    end
  end
end
