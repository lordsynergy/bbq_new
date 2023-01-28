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
      set_flash_message(:notice, :success, kind: provider)

    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']

     redirect_to root_path
    end
  end

end