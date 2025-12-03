# app/controllers/admin/users_controller.rb

class Admin::UsersController < ApplicationController

  layout "admin"
  before_action :authenticate_user!
  # before_action :set_user, only: [:destroy, :edit, :update]
  load_and_authorize_resource class: "User"

  def index
    @users
  end

  def show
    @user
  end

  def update
    Rails.logger.debug "Parámetros recibidos: #{user_params.inspect}"
    user_data = user_params

    if user_data[:role].present?
      authorize! :change_role, @user
    end

    if user_data[:password].blank? && user_data[:password_confirmation].blank?
      user_data.delete(:password)
      user_data.delete(:password_confirmation)
    end
    if @user.update(user_data)
      redirect_to edit_admin_user_path, notice: "El usuario #{@user.email} fue
actualizado
correctamente."
    else
      # Si falla la validación, vuelve al formulario de edición, mostrando
      # los errores por el status de error
      render :edit, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :role)
  end

  def edit
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
    @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path, alert: "Usuario no encontrado."
    end
end