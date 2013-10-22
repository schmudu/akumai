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
    delete destroy_user_session_path
  end
end