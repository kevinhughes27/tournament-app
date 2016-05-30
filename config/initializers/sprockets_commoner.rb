Rails.application.config.assets.configure do |env|
  env.unregister_postprocessor('application/javascript', Sprockets::Commoner::Processor)
  env.register_postprocessor('application/javascript', Sprockets::Commoner::Processor.new(
    env.root,
    include: ['app/assets/javascripts/admin', 'node_modules'],
    exclude: ['app/assets/javascripts/vendor']
  ))
end
