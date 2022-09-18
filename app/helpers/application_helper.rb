module ApplicationHelper
  def bi_icon(icon_class)
    content_tag 'span', '', class: "bi bi-#{icon_class}"
  end

  def event_lg_thumb(event)
    photos = event.photos.persisted

    if photos.any?
      url_for photos.sample.photo.variant(:medium)
    else
      asset_path('event.jpg')
    end
  end

  def event_thumb(event)
    photos = event.photos.persisted

    if photos.any?
      url_for photos.sample.photo.variant(:thumb)
    else
      asset_path('event_thumb.jpg')
    end
  end

  def user_avatar(user)
    if user.avatar.attached?
      url_for user.avatar.variant(:default)
    else
      asset_path('user.png')
    end
  end

  def user_avatar_thumb(user)
    if user.avatar.attached?
      user.avatar.variant(:thumb)
    else
      asset_path('user.png')
    end
  end
end
