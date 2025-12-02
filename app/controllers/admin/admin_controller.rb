class Admin::AdminController < ApplicationController

  before_action :authenticate_user!

  layout "admin"
  def home
    # Admin dashboard logic here
  end
end
