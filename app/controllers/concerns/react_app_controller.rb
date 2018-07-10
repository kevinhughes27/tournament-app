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
    render file: index_html
  end

  def static
    file = static_file(params[:dir], params[:file], params[:format])
    if File.exist?(file)
      render file: file
    else
      redirect_to_latest(params[:dir], params[:file], params[:format])
    end
  end

  def service_worker
    render file: service_worker_file
  end

  private

  def index_html
    Rails.root.join(clients_directory, app_directory, 'build', 'index.html')
  end

  def static_file(dir, file, extension)
    Rails.root.join(clients_directory, app_directory, 'build', 'static', dir, "#{file}.#{extension}")
  end

  def redirect_to_latest(dir, file, extension)
    file_glob = Rails.root.join(clients_directory, app_directory, 'build', 'static', dir, '*')
    file_path = Dir[file_glob].find{ |f| f.end_with?(".#{extension}") }
    file = file_path.split('/').last
    redirect_to "/static/#{dir}/#{file}"
  end

  def service_worker_file
    Rails.root.join(clients_directory, app_directory, 'build', 'service-worker.js')
  end

  def clients_directory
    'clients'
  end
end
