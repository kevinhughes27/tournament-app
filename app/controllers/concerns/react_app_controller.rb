module ReactAppController
  extend ActiveSupport::Concern

  included do
    layout false
    protect_from_forgery except: [:index, :static, :service_worker]

    def self.app_name(name)
      define_method :app_directory do
        name
      end
    end
  end

  def index
    html = File.read(index_html)
    html.gsub!("[CSRF_TOKEN]", form_authenticity_token)
    render html: html.html_safe
  end

  def static
    file = static_file(params[:dir], params[:file], params[:format])
    if File.exist?(file)
      send_file file
    else
      requested_file_name = params[:file].split('.').first
      redirect_to_latest(params[:dir], requested_file_name, params[:format])
    end
  end

  def service_worker
    send_file service_worker_file
  end

  private

  def index_html
    Rails.root.join(clients_directory, app_directory, 'build', 'index.html')
  end

  def static_file(dir, file, extension)
    Rails.root.join(clients_directory, app_directory, 'build', 'static', dir, "#{file}.#{extension}")
  end

  def redirect_to_latest(dir, requested_file_name, extension)
    file_glob = Rails.root.join(clients_directory, app_directory, 'build', 'static', dir, "*.#{extension}")

    latest_file = Dir[file_glob].find do |file|
      built_file = file.split('/').last
      built_file_name = built_file.split('.').first

      # chunk bundle
      found_latest_file = if requested_file_name.is_i?
        built_file_name.starts_with?(requested_file_name) || built_file_name.is_i?
      elsif requested_file_name.include?('~')
        requested_file_name.gsub('~', '-') == built_file_name
      # named bundle
      else
        built_file_name == requested_file_name
      end

      found_latest_file
    end

    redirect_to "/static/#{dir}/#{latest_file}"
  end

  def service_worker_file
    Rails.root.join(clients_directory, app_directory, 'build', 'service-worker.js')
  end

  def clients_directory
    'clients'
  end
end
