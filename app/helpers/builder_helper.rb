module BuilderHelper
  def builder_card(error: false, back: false)
    animation = if error
      'pulse'
    elsif back
      'bounceInLeft'
    else
      'bounceInRight'
    end

    content_tag(:div, class: "builder-card animated #{animation}") do
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
