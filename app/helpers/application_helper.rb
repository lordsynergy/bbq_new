module ApplicationHelper
  def user_avatar(user)
    asset_path('user.png')
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "bi bi-#{icon_class}"
  end
end
