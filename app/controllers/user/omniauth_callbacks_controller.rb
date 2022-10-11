class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    authorize_oauth_user(from_google_params)
  end

  def github
    authorize_oauth_user(from_github_params)
  end

  def vkontakte
    authorize_oauth_user(from_vkontakte_params)
  end

  def authorize_oauth_user(params)
    @user = User.oauth(params)

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: params[:kind])
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:error] = I18n.t(
        'devise.omniauth_callbacks.failure',
        kind: params[:kind],
        reason: 'authentication error'
      )

      redirect_to new_user_session_path
    end
  end

  def from_vkontakte_params
    @from_vkontakte_params ||= {
      provider: auth.provider,
      name: auth.info.name,
      uid: auth.extra.raw_info.id,
      email: auth.info.email,
      url: auth.extra.raw_info.html_url,
      kind: 'VK'
    }
  end

  def from_google_params
    @from_google_params ||= {
      provider: auth.provider,
      name: auth.info.name,
      uid: auth.uid,
      email: auth.info.email,
      kind: 'Google'
    }
  end

  def from_github_params
    @from_github_params ||= {
      provider: auth.provider,
      name: auth.info.name,
      uid: auth.extra.raw_info.id,
      email: auth.info.email,
      url: "https://github.com/#{uid}",
      kind: 'Github'
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
