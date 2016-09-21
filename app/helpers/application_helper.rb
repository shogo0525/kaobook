module ApplicationHelper
  def profile_img(user)
    size = "50x50"
    return image_tag(user.avatar, size: size, alt: user.name) if user.avatar?

    unless user.provider.blank?
      img_url = user.image_url
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, size: size, alt: user.name)
  end

  def is_friend(sender_id, recipient_id)
    sender = User.find(sender_id)
    recipient = User.find(recipient_id)
    if sender.following?(recipient) && recipient.following?(sender)
      return true
    else
      return false
    end
  end
end
