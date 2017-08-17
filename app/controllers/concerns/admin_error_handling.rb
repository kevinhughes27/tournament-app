module AdminErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from(ActiveRecord::RecordNotFound, with: :render_admin_404)
  end

  def render_admin_404
    respond_to do |format|
      format.html { render 'admin/404', status: :not_found }
      format.any  { head :not_found }
    end
  end
end
