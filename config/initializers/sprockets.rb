Rails.application.config.assets.configure do |env|
  env.unregister_postprocessor('application/javascript', Sprockets::Commoner::Processor)
  processor = Sprockets::Commoner::Processor.new(
    env.root,
    include: [
      'app/assets/javascripts/admin',
      'node_modules',
    ],
    exclude: [
      'app/assets/javascripts/vendor',
      'app/assets/javascripts/app',
      'app/assets/javascripts/brochure',
      'app/assets/javascripts/internal',
      'app/assets/javascripts/shared',
    ],
    babel_exclude: [
      /node_modules/,
    ]
  )
  env.register_postprocessor('application/javascript', processor)
end
