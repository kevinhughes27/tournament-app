class AppController < ApplicationController
  include TournamentConcern

  layout false
  protect_from_forgery except: [:index, :static, :service_worker]

  def index
    render file: index_html
  end

  def static
    render file: static_file(params[:dir], params[:file])
  end

  def service_worker
    render file: index_service_worker_file
  end

  private

  def index_html
    Rails.root.join(app_directory, 'build', 'index.html')
  end

  def static_file(dir, file)
    Rails.root.join(app_directory, 'build', 'static', dir, file)
  end

  def index_service_worker_file
    Rails.root.join(app_directory, 'build', 'service-worker.js')
  end

  def app_directory
    'player-app'
  end
end
