class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Este método atrapa la excepción CanCan::AccessDenied
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message || "No estás autorizado para realizar esta acción."
    redirect_back(fallback_location: root_url, alert: exception.message)
  end

  # Redirect to unauthenticated
  def authenticate_user!
    unless current_user
      store_location_for(:user, request.fullpath)
      redirect_to new_admin_user_session_path, alert: "Debes iniciar sesión para acceder a esta
página."
    end
  end

  # Set parameters for gem Devise
  def configure_permitted_parameters
    # allow additional parameters for sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])

    # allow additional parameters for account update
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

  # Redirect to login (gem devise), resource is the current_user
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_users_path # Asumiendo que tienes esta ruta definida
    elsif resource.manager?
      admin_users_path
    else
      admin_root_path
    end
  end
end
