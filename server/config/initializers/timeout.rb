# config/initializers/timeout.rb
begin
  Rack::Timeout.timeout = 20  # seconds
rescue
  # dont care
end
