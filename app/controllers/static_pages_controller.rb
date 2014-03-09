class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!, :only => [:help]
  def home
    @test_var = CONFIG[:host]
  end

  def help
  end
end
