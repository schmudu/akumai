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
      visit programs_path 
      login user
    end

    it "should forward to programs path" do
      current_path.should == programs_path
    end
  end

  describe "with logging in" do
    before(:each) do 
      login user
      visit root_path 
    end

    describe "menu options" do
      it { should have_link("Programs", programs_path) }
      it "should go to the programs pages" do
        click_link "Programs"
        expect(page).to have_title(full_title('Programs'))
      end
    end

    describe "on index page" do
      describe "pagination" do
        before do
          31.times { FactoryGirl.create(:program) }
          visit programs_path
        end
        after(:all) { Program.delete_all }

        it { should have_selector('div.pagination') }
        it { should have_title(full_title('Programs')) }
        it { should have_link("Create Program", new_program_path) }

        it "should list each program" do
          Program.paginate(page: 1).each do |program|
            expect(page).to have_selector('li', text: program.name)
          end
        end
      end
    end
  end
end
