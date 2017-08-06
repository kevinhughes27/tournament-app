module AdminErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from(ActiveRecord::RecordNotFound, with: :render_admin_404)
    rescue_from(StandardError, with: :render_admin_500)
  end

  def render_admin_404
    respond_to do |format|
      format.html { render 'admin/404', status: :not_found }
      format.any  { head :not_found }
    end
  end

  def render_admin_500
    Rollbar.error(e)

    respond_to do |format|
      format.html { render 'admin/500', status: 500 }
      format.any  { head 500 }
    end
  end
end
