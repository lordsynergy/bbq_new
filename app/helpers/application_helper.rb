module ApplicationHelper
  def fa_icon(icon_class)
    content_tag 'span', '', class: "bi bi-#{icon_class}"
  end

  def fa_icon_provider(icon_class)
    content_tag 'i', '', class: icon_class
  end

  def user_avatar(user)
    if user.avatar.attached? && user.avatar.variable?
      user.avatar.variant(:thumb_big)
    else
      asset_path('user.png')
    end
  end

  def user_avatar_thumb(user)
    if user.avatar.attached? && user.avatar.variable?
      user.avatar.variant(:thumb)
    else
      asset_path('user.png')
    end
  end

  def event_photo(event)
    photos = event.photos.persisted

    if photos.any?
      photos.sample.photo.url
    else
      asset_path('event.jpg')
    end
  end

  def event_thumb(event)
    photos = event.photos.persisted

    if photos.any?
      photos.sample.photo.thumb.url
    else
      asset_path('event_thumb.jpg')
    end
  end
end
