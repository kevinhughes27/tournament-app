module AdminErrorHandling
  extend ActiveSupport::Concern

  included do
    protected

    unless Rails.application.config.consider_all_requests_local
      rescue_from StandardError do |e|
        if e.is_a?(ActiveRecord::RecordNotFound)
          render_admin_404
        else
          Rollbar.error(e)
          render_admin_500
        end
      end
    end

    def render_admin_404
      respond_to do |format|
        format.html { render 'admin/404', status: :not_found }
        format.any  { head :not_found }
      end
    end

    def render_admin_500
      respond_to do |format|
        format.html { render 'admin/500', status: 500 }
        format.any  { head 500 }
      end
    end
  end
end
