class User < ActiveRecord::Base
  has_many :tournament_users
  has_many :tournaments, through: :tournament_users

  devise :custom_authenticatable,
         :database_authenticatable,
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

  def valid_for_custom_authentication?(password)
    tournaments.exists?(id: Thread.current[:tournament_id])
  end

  private

  def gravatar_hash
    email.present? ? Digest::MD5.hexdigest(email) : ''
  end
end
