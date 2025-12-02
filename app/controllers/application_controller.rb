class ApplicationController < ActionController::Base
  # Only allow modern browsers
  allow_browser versions: :modern

  # Require login for all controllers by default
  before_action :authenticate_user!

  # Permit extra parameters for Devise (role)
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Redirect user to dashboard after login
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # Permit role for sign up / account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end
end
