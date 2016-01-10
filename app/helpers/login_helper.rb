module LoginHelper
  def login_animation
    if flash[:alert].present?
      'pulse'
    else
      'fadeInDown'
    end
  end
end
