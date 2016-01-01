class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  def name
    email.split('@').first
  end

  def gravatar_url
    "http://www.gravatar.com/avatar/#{gravatar_hash}?s=200&d=mm"
  end

  private

  def gravatar_hash
    email.present? ? Digest::MD5.hexdigest(email) : ''
  end
end
