require 'spec_helper'

describe "ProgramPages" do
  before(:all) { User.delete_all }
  let(:user) { FactoryGirl.create(:user, superuser: true) }
  subject { page }
  describe "without logging in" do
    before { visit programs_path }
    it { should_not have_link("Create Programs", new_program_path) }
    it { should_not have_title(full_title('Programs')) }
  end

  describe "after logging in" do
    before(:each) do 
      login user
      visit root_path 
    end
    it { should have_link("Programs", programs_path) }
    it "should go to the programs pages" do
      click_link "Programs"
      expect(page).to have_title(full_title('Programs'))
    end

  end

  describe "pagination" do
    #let(:other_user) { FactoryGirl.create(:user, superuser: true) }
    #before(:each) do
    before do
      31.times { FactoryGirl.create(:program) }
      login user
      visit programs_path
    end
    after(:all) { Program.delete_all }
=begin
    before(:all) {30.times { FactoryGirl.create(:program) }}
    after(:all) { Program.delete_all }
=end

    it "test count" do
      expect(Program.count).should eq(31)
    end

    it do 
      #save_and_open_page
      should have_selector('div.pagination')
    end 
    it { should have_title(full_title('Programs')) }

    it "should list each program" do
      Program.paginate(page: 1).each do |program|
        expect(page).to have_selector('td', text: program.name)
      end
    end
  end
end
