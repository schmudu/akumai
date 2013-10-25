require 'spec_helper'

describe "Dashboards" do
  subject { page }
  describe "for a superuser" do
    describe "after signing in" do
      let(:user) do 
        FactoryGirl.create(:user, :superuser => true)
      end

      before do 
        login user
      end
      
=begin
      describe "title of Dashboard" do
        before { click_link "#{user.email}"}
        it { should have_link('Sign out', href: destroy_user_session_path) }
        it { should have_link('Edit profile', href: edit_user_registration_path) }
      end
=end
      
      # programs
      it { should have_title(full_title('User Dashboard')) }
      it { should have_link("Create Program", href: new_program_path) }
      it { should have_link("Edit Programs", href: programs_path) }

      # users and invitations
       
      # reports 
      
    end
  end
end
