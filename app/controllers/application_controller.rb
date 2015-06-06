class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def download_csv_template
    send_file 'template.csv', :disposition => 'attachment'
  end

end
