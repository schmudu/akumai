require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:superuser) }

  # user types
  it { should respond_to(:is_superuser?) }

  describe "after creation should be student by default" do
    its(:is_superuser?) { should eq(false) }
  end

  describe "set superuser to true" do
    before do 
      @user.superuser = true 
      @user.save
    end
    its(:is_superuser?) { should eq(true) }
  end
end
