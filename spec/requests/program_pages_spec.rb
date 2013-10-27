require 'spec_helper'

describe "ProgramPages" do
  let(:user) { FactoryGirl.create(:user) }
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
    it { should have_link("Create Programs", new_program_path) }
  end
end
