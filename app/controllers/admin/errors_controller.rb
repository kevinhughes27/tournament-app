class Admin::ErrorsController < AdminController
  def not_found
    render '404'
  end
end
