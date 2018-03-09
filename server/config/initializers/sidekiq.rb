if Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: Settings.job_redis_url, size: 3 }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: Settings.job_redis_url, size: 10 }
  end
end
