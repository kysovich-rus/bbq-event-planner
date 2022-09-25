class User::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :check_captcha, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def check_captcha
    unless verify_recaptcha
      flash[:alert] = t('activerecord.controllers.users.recaptcha_failed')
      self.resource = resource_class.new sign_up_params
      respond_with_navigational(resource) { render :new }
    end
  end
end
