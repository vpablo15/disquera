class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Este método atrapa la excepción CanCan::AccessDenied
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message || "No estás autorizado para realizar esta acción."
    redirect_back(fallback_location: root_url, alert: exception.message)
  end
end
