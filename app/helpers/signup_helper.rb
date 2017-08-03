module SignupHelper
  def signup_card(error: false)
    animation = if error
      'pulse'
    else
      'bounceInRight'
    end

    style = if error
      duration = 0.7
      "-webkit-animation-duration: #{duration}s; -moz-animation-duration: #{duration}s; -ms-animation-duration: #{duration}s;"
    end

    content_tag(:div, class: "signup-card animated #{animation}", style: style) do
      content_tag(:div, class: 'modal-content') do
        yield
      end
    end
  end
end
