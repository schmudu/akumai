include ApplicationHelper

def get_attachment_file_path file_name
  File.join(Rails.root,"/spec/fixtures/files/",file_name)
end

def login(user, options={})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit new_user_session_path
    fill_in "user[email]",      with: user.email
    fill_in "user[password]",   with: user.password
    click_button "Sign in"
  end
end

def logout(user, options={})
  if options[:no_capybara]
    cookies.delete(:remember_token)
  else
    visit root_path
    click_link "#{user.email}"
    click_link "Sign out"
  end
end

# custom matchers
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end
