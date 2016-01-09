module LoginHelper
  def login_animation
    if flash[:alert] && flash[:alert] != 'You need to sign in or sign up before continuing.'
      'pulse'
    else
      'fadeInDown'
    end
  end
end
