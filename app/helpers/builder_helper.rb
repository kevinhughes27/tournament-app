module BuilderHelper
  def builder_card(error: false, back: false)
    animation = if back
      'bounceInLeft'
    elsif error
      'pulse'
    else
      'bounceInRight'
    end

    style = if error
      duration = 0.7
      "-webkit-animation-duration: #{duration}s; -moz-animation-duration: #{duration}s; -ms-animation-duration: #{duration}s;"
    end

    content_tag(:div, class: "builder-card animated #{animation}", style: style) do
      tag(:div, class: 'spacer')
      content_tag(:div, class: 'modal-content col-md-6 col-md-offset-3') do
        yield
      end
    end
  end

  def is_back?
    session[:previous_step] == next_wizard_path
  end

end
