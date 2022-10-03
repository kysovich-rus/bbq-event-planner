class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_google(from_google_params)

    if user.present?
      sign_out_all_scopes
      flash[:notice] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
  end

  def from_google_params
    @from_google_params ||= {
      provider: auth.provider,
      name: auth.info.name,
      uid: auth.uid,
      email: auth.info.email
    }
  end

  def github
    @user = User.from_github(from_github_params)

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Github')
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:error] = I18n.t(
        'devise.omniauth_callbacks.failure',
        kind: 'Github',
        reason: 'authentication error'
      )

      redirect_to new_user_session_path
    end
  end

  def from_github_params
    @from_github_params ||= {
      provider: auth.provider,
      name: auth.info.name,
      uid: auth.extra.raw_info.id,
      email: auth.info.email
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
