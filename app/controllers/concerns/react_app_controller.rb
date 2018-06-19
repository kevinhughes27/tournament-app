module ReactAppController
  extend ActiveSupport::Concern

  included do
    layout false
    protect_from_forgery except: [:index, :static, :service_worker]

    def self.app_name(name)
      @@app_directory = name
    end
  end

  def index
    render file: index_html
  end

  def static
    render file: static_file(params[:dir], params[:file])
  end

  def service_worker
    render file: service_worker_file
  end

  private

  def index_html
    Rails.root.join(clients_directory, @@app_directory, 'build', 'index.html')
  end

  def static_file(dir, file)
    Rails.root.join(clients_directory, @@app_directory, 'build', 'static', dir, file)
  end

  def service_worker_file
    Rails.root.join(clients_directory, @@app_directory, 'build', 'service-worker.js')
  end

  def clients_directory
    'clients'
  end
end
