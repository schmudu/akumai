require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have the content 'Home'" do
      visit '/static_pages/home'
      expect(page).to have_content("Home")
    end

    it "should have the title 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_title("TRIO | Home")
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content("Help")
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_title("TRIO | Help")
    end
  end
end
