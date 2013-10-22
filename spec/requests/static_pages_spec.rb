require 'spec_helper'

describe "StaticPages" do
  subject { page }
  describe "Home page" do
    it "should have the content 'Home'" do
      visit root_path
      #expect(page).to have_content("Home")
      expect(page).to have_content("Home")
    end

    it "should have the title 'Sample App'" do
      #before { get static_pages_home_path }
      #it { should have_title('TRIO | Home') }
      visit static_pages_home_path
      page.should have_title("TRIO | Home")
    end
  end

  describe "Help page" do
    let (:user) { FactoryGirl.create(:user) }
    before do
      login user
      visit static_pages_help_path
    end

    it { should have_content("Help")}
    it { should have_title(full_title("Help")) }
  end
end
