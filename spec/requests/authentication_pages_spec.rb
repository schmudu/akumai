require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "visiting help page" do
    describe "without signing in" do
      before { visit root_path }
      it { should have_content('Sign up') }
      it { should have_content('Login') }
    end

    describe "with signing in" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        login user
      end
      
      it { should have_link('Logout', href: destroy_user_session_path) }
      it { should have_link('Edit profile', href: edit_user_registration_path) }
      it { should have_title(full_title('User Dashboard')) }
    end

    describe "with signing in and signing out" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        login user
        logout user
        visit root_path 
      end
      
      it { should have_link('Sign up', href: new_user_registration_path) }
      it { should have_link('Login', href: new_user_session_path) }
    end
  end
end
