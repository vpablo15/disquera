# app/controllers/admin/users_controller.rb

class Admin::UsersController < ApplicationController

  layout "admin"
  # Esta acción maneja la ruta GET /admin/users

  before_action :set_user, only: [:destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "No puedes eliminar tu propia cuenta de administrador."
      return
    end

    if @user.destroy
      redirect_to admin_users_path, notice: "El usuario #{@user.email} ha sido eliminado con éxito."
    else
      redirect_to admin_users_path, alert: "No se pudo eliminar al usuario."
    end
  end

  private

  # Hook para recuperar el usuario cuando se recibe el id por parámetro
  def set_user
    Rails.logger.debug "Intentando buscar usuario con ID: #{params[:id]}"
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path, alert: "Usuario no encontrado."
    end
end