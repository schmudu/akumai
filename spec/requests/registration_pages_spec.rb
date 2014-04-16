require 'spec_helper'

require_relative '../../app/helpers/constants_helper'

describe "RegistrationPages" do
  before do
    @password = "foobar123"
    visit new_user_registration_path
    fill_in "user_email", :with => "abc@abc.com"
    fill_in "user_password", :with => @password
    fill_in "user_password_confirmation", :with => @password
    click_button I18n.t('terms.sign_up')
    @user = User.last
  end
  it "queues mail when a contact is created" do
    MailRegistrationUserJob.should have_queued(@user.id).in(:mail)
  end
end
