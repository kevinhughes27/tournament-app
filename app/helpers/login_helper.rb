module LoginHelper
  def login_animation
    if flash[:alert].present?
      'pulse'
    else
      'fadeInDown'
    end
  end

  def password_reset_animation(resource)
    'pulse' if resource.errors.present?
  end
end
