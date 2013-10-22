require 'spec_helper'

describe "AuthenticationPages" do
  describe "visiting help page" do
    before { visit '/static_pages/help' }
    specify { expect(response).to redirect_to(new_user_session_path)}
  end
end
