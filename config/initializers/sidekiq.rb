if Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDIS_URL"], size: 3 }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end
end
