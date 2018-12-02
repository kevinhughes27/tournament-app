class DeviseMailer < Devise::Mailer
  def default_url_options
    {
      :host => host,
      :port => port
    }
  end

  private

  def host
    Settings.host
  end

  def port
    3000 unless Rails.env.production?
  end

end
