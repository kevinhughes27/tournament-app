module FlashHelper
  def flash_error?
    flash[:alert].present? || flash[:error].present?
  end

  def flash_message
    [flash[:notice], flash[:error], flash[:alert]].compact.flatten.to_sentence
  end
end
