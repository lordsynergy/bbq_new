class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte yandex]

  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, length: {maximum: 35}

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :thumb_big, resize_to_limit: [350, 350]
  end

  validates :avatar, file_size: { less_than_or_equal_to: 2.megabytes },
            file_content_type: { allow: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] }

  after_commit :link_subscriptions, on: :create

  def self.find_service_oauth(access_token)
    user = User.find_by(email: access_token.info.email)

    return user if user.present?

    User.where(provider: access_token.provider, url: access_token.url).first_or_create! do |new_user|
      new_user.name = access_token.info.name
      new_user.email = access_token.info.email
      new_user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
      .update_all(user_id: self.id)
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
