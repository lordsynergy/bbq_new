require 'open-uri'
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

  def self.find_service_oauth(auth)
    user = where(provider: auth.provider, id: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
      user.url = auth.info.url
    end

    if auth.provider == 'yandex'
      url = "https://avatars.yandex.net/get-yapic/#{auth.extra.raw_info.default_avatar_id}/islands-200"
      user.avatar.attach(io: URI.open(url), filename: 'avatar')
    else
      user.avatar.attach(io: URI.open(auth.info.image), filename: 'avatar')
    end

    user
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
