require 'sprockets'

class DependOnFileDirectiveProcessor < Sprockets::DirectiveProcessor
  def process_depend_on_file_directive(path)
    uri, deps = @environment.resolve!(path, load_paths: [::Rails.root.to_s])
    @dependencies.merge(deps)
    uri
  end

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
