module FlashHelper
  def flash_error?
    flash[:error].present?
  end

  def flash_message
    flash[:error] || flash[:notice]
  end
end
