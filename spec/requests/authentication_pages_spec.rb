require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "visiting help page" do
    describe "without signing in" do
      before { visit static_pages_help_path }
      it { should_not have_title(full_title("Help")) }
    end

    describe "with signing in" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        login user
        visit static_pages_help_path 
      end
      
      it { should have_title(full_title("Help")) }
    end
  end
end
