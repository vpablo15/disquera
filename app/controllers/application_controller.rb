class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Este método atrapa la excepción CanCan::AccessDenied
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message || "No estás autorizado para realizar esta acción."
    redirect_back(fallback_location: root_url, alert: exception.message)
  end

  # Set parameters for gem Devise
  def configure_permitted_parameters
    # allow additional parameters for sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])

    # allow additional parameters for account update
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end
end
