class DirectiveProcessor < Sprockets::DirectiveProcessor
  def process_depend_on_file_directive(path)
    _, deps = @environment.resolve!(path, load_paths: [::Rails.root.to_s])
    @dependencies.merge(deps)
  end

  def process_depend_on_files_directive(glob)
    Dir["#{glob}"].sort.each do |filename|
      _, deps = @environment.resolve!(filename, load_paths: [::Rails.root.to_s])
      @dependencies.merge(deps)
    end
  end
end

Rails.application.config.assets.configure do |env|
  env.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
  env.register_processor('application/javascript', DirectiveProcessor)
end
