require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "visiting help page" do
    describe "without signing in" do
      before { visit root_path }
      it { should have_content('Sign up') }
      it { should have_content('Login') }

      describe "should not show the sub navbar" do
        it { should_not have_xpath("//div[@class='navbar' and @id='navbar_sub']") }
      end
    end

    describe "with signing in" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        login user
      end
      
      describe "should have links" do
        before { click_link "#{user.email}"}
        it { should have_link('Sign out', href: destroy_user_session_path) }
        it { should have_link('Edit profile', href: edit_user_registration_path) }
        it { should have_link('Invite Users', href: invite_users_type_path) }
        it { should have_title(full_title('User Dashboard')) }
      end
      
      describe "with superuser" do
        let(:user_superuser) { FactoryGirl.create(:user, superuser: true) }

        describe "should have all dashboard links" do
          it { should have_link('Dashboard', href: '#') }
          it { should have_link('Dashboard Home', href: dashboard_path) }
          it { should have_link('Programs', href: programs_path) }
          it { should have_link('Admin', href: "#") }
          it { should have_link('Staff', href: "#") }
          it { should have_link('Students', href: "#") }
        end

        describe "should show the sub navbar" do
          it { should have_xpath("//div[@class='navbar' and @id='navbar_sub']") }
        end
      end
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
