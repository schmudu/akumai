require 'spec_helper'

describe "ProgramPages" do
  let(:user) { FactoryGirl.create(:user, superuser: true) }
  subject { page }
  describe "without logging in" do
    before { visit root_path }
    it { should_not have_link("Create Programs", new_program_path) }
  end

  describe "after logging in" do
    before do 
      login user
      visit root_path 
    end
    it { should have_link("Programs", programs_path) }
    it "should go to the programs pages" do
      click_link "Programs"
      expect(page).to have_title(full_title('Programs'))
    end
  end
end
