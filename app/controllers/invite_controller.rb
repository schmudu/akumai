class InviteController < ApplicationController
  before_filter :authenticate_user!, except: [:signup]
  def show
  end

  def respond
  end

  def signup
    @user = User.new
  end
end
