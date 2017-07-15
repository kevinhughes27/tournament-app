module ResponsiveHelpers
  extend ActiveSupport::Concern

  def resize_window_to_mobile
    resize_window(640, 480)
  end

  def resize_window_to_tablet
    resize_window(960, 640)
  end

  def resize_window_default
    resize_window(1024, 768)
  end

  private

  def resize_window(width, height)
    Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
  end
end
