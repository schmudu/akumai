require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "About page" do
    before { visit about_path }

    it { should have_content("About") }
    it { should have_title(full_title("About TRIO")) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content("Contact")}
    it { should have_title(full_title("Contact")) }
  end

  describe "Help page" do
    #let (:user) { FactoryGirl.create(:user) }
    before do
      #login user
      visit help_path
    end

    it { should have_content("Help")}
    it { should have_title(full_title("Help")) }
  end

  describe "Home page" do
    before { visit root_path }

    it { should have_content("Home") }
    it { should have_title(full_title("Home")) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About TRIO'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title('Home'))
  end
end
