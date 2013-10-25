include ApplicationHelper

def login(user, options={})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit new_user_session_path
    fill_in "Email",      with: user.email
    fill_in "Password",   with: user.password
    click_button "Sign in"
  end
end

def logout(user, options={})
  if options[:no_capybara]
    cookies.delete(:remember_token)
  else
    visit root_path
    #click_link "Logout"
    click_link "#{user.email}"
    click_link "Sign out"
    #page.find(:xpath, "//a[@href='/users/sign_out']").click
  end
end

# custom matchers
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end