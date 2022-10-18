class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    authorize_oauth_user("Google")
  end

  def github
    authorize_oauth_user("Github")
  end

  def vkontakte
    authorize_oauth_user("VK")
  end

  def authorize_oauth_user(kind)
    @user = User.from_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: kind)
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:error] = I18n.t(
        'devise.omniauth_callbacks.failure',
        kind: kind,
        reason: 'authentication error'
      )
      redirect_to new_user_session_path
    end
  end
end
