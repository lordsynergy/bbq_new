class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_service('Github')
  end

  def vkontakte
    oauth_service('Vkontakte')
  end

  private

  def oauth_service(provider)
    if @user.persisted?
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?

      sign_in_and_redirect user, event: :authentication
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']

      redirect_to new_user_registration_url
    end
  end

  def set_user
    @user = User.from_omniauth(request.env['omniauth.auth'])
  end
end