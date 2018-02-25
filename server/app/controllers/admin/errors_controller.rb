class Admin::ErrorsController < AdminController
  def not_found
    render_admin_404
  end
end
