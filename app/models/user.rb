class User < ApplicationRecord
  has_many :user_authentications, dependent: :destroy
  has_many :tournament_users, dependent: :destroy
  has_many :tournaments, through: :tournament_users

  devise :omniauthable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  after_commit :subscribe_to_mailchimp, on: :create

  def self.from_omniauth(auth)
    authentication = UserAuthentication.where(provider: auth.provider, uid: auth.uid.to_s).first_or_initialize

    if authentication.user.blank?
      user = User.find_by(email: auth.info.email)
      user = User.create!(email: auth.info.email, password: Devise.friendly_token[0, 20]) if user.blank?
      authentication.user = user
      authentication.save!
    end
    authentication.user
  end

  STAFF = [
    'kevinhughes27@gmail.com',
    'samcluthe@gmail.com'
  ]

  def staff?
    STAFF.include?(email)
  end

  def name
    email.split('@').first
  end

  def gravatar_url
    "https://www.gravatar.com/avatar/#{gravatar_hash}?s=200&d=mm"
  end

  def is_tournament_user?(tournament_id)
    tournaments.exists?(id: tournament_id)
  end

  private

  def gravatar_hash
    email.present? ? Digest::MD5.hexdigest(email) : ''
  end

  def subscribe_to_mailchimp
    return unless Rails.env.production?

    api_key = ENV['MAILCHIMP_API_KEY']
    gibbon = Gibbon::Request.new(api_key: api_key)

    gibbon.lists('5614c3cf70').members.create(body: {
      email_address: email, status: "subscribed"
    })

  rescue Exception => e
    Rollbar.error(e)
  end
end
