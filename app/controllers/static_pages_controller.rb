class StaticPagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:help]
  def home
  end

  def help
  end
end
