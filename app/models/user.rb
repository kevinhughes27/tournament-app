class User < ActiveRecord::Base
  has_many :tournament_users
  has_many :tournaments, through: :tournament_users

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

  def is_tournament_user?(tournament_id)
    tournaments.exists?(id: tournament_id)
  end

  private

  def gravatar_hash
    email.present? ? Digest::MD5.hexdigest(email) : ''
  end
end
