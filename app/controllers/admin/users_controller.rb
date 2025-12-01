# app/controllers/admin/users_controller.rb

class Admin::UsersController < ApplicationController

  layout "admin"
  # Esta acción maneja la ruta GET /admin/users
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

end