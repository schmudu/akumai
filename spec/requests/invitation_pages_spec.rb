require 'spec_helper'

describe "InvitationPages" do
  let(:user) { FactoryGirl.create(:user, superuser: true) }
  let(:program) { FactoryGirl.create(:program) }
  before(:each) { login user }
  subject { page }
  describe "without logging in" do
    before { visit invite_users_path(program.id) }
    #it { should_not have_link("Create Programs", new_program_path) }
    it { should have_title(full_title('Invite Users')) }
  end
end
