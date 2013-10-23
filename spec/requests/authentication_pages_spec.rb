require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "visiting help page" do
=begin
    describe "without signing in" do
      before { visit help_path }
      it { should_not have_title(full_title("Help")) }
    end

    describe "with signing in" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        login user
        visit help_path 
      end
      
      it { should have_title(full_title("Help")) }
    end
=end
  end
end
