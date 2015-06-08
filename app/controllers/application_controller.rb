class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def download_csv_template
    send_file 'template.csv', :disposition => 'attachment'
  end

    def handle_example
    @handler_example = Tournament.new(name: params[:name])
    if request.xhr?
        render :json => {
                          :handle_example => ("Your tournament's URL will read as:  " + root_url + @handler_example.send(:set_handle)).to_s
                        }
    end
    @handler_example.destroy
  end

end
