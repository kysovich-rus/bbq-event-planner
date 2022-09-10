class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?

  private

  def current_user_can_edit?(event)
    user_signed_in? && event.user == current_user
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
    :account_update,
    keys: %i[password password_confirmation current_password]
    )
  end

  def redirect_with_alert
    redirect_to root_path, alert: 'Доступ запрещен!'
  end
end
