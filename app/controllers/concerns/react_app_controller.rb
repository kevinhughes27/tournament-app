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
      name = params[:file].split('.').first
      redirect_to_latest(params[:dir], name, params[:format])
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

  def redirect_to_latest(dir, name, extension)
    file_glob = Rails.root.join(clients_directory, app_directory, 'build', 'static', dir, "*.#{extension}")

    new_file = Dir[file_glob].find do |file|
      full_file_name = file.split('/').last
      full_file_name.starts_with?(name)
    end

    redirect_to "/static/#{dir}/#{new_file}"
  end

  def service_worker_file
    Rails.root.join(clients_directory, app_directory, 'build', 'service-worker.js')
  end

  def clients_directory
    'clients'
  end
end
