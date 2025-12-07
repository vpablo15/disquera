class Admin::UserSessionController < ApplicationController
  def new
    @user = User.new
  end
end
