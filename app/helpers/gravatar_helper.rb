module GravatarHelper
  def gravatar(email)
    hash = email.present? ? Digest::MD5.hexdigest(email) : ''
    "https://www.gravatar.com/avatar/#{hash}?s=200&d=mm"
  end
end
