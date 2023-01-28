class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_service('Github')
  end

  def vkontakte
    oauth_service('Vkontakte')
  end

  def yandex
    oauth_service('Yandex')
  end

  private

  def oauth_service(provider)
    if @user.persisted?
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: provider)
      sign_in_and_redirect user, event: :authentication
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']

      redirect_to root_path
    end
  end

  def user
    @user = User.find_service_oauth(request.env['omniauth.auth'])
  end
end