class DeviseMailer < Devise::Mailer
  def default_url_options
    {
      protocol: 'https',
      host: host,
      port: port
    }
  end

  def invitation_instructions(user, token, opts={})
    @token = token

    # invited user will always have exactly 1 tournament
    @tournament = user.tournaments.first

    devise_mail(user, :invitation_instructions, opts)
  end

  private

  def host
    Settings.host
  end

  def port
    3000 unless Rails.env.production?
  end
end
