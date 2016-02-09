module UiHelper
  class UiFormBuilder < ActionView::Helpers::FormBuilder
    delegate :content_tag, :capture, :concat, to: :@template

    def ui_text_field(method, options = {})
      content_tag(:div, class: 'form-group') do
        concat label(method)
        concat text_field(method, options.merge(class: 'form-control'))
      end
    end

    def ui_password_field(method, options = {})
      content_tag(:div, class: 'form-group') do
        concat label(method)
        concat password_field(method, options.merge(class: 'form-control'))
      end
    end

    def ui_number_field(method, options = {})
      content_tag(:div, class: 'form-group') do
        concat label(method)
        concat number_field(method, options.merge(class: 'form-control'))
      end
    end

    def ui_select_field(method, label, options)
      content_tag(:div, class: 'form-group') do
        concat label(method, label)
        concat select method, options, {}, class: 'form-control'
      end
    end

    def ui_save_button
      content_tag(:div, class: 'form-group') do
        submit('Save', class: 'btn btn-primary pull-right js-btn-loadable')
      end
    end
  end

  def form_for(record, options = {}, &block)
    options.reverse_merge!(builder: UiHelper::UiFormBuilder)
    super(record, options, &block)
  end

  def fields_for(record_name, record_object = nil, options = {}, &block)
    options.reverse_merge!(builder: UiHelper::UiFormBuilder)
    super(record_name, record_object, options, &block)
  end

  def ui_save_button_tag(form_id = nil)
    if form_id
      button_tag 'Save', class: "btn btn-primary js-btn-loadable", onclick: "$('#{form_id}').submit()"
    else
      button_tag 'Save', class: "btn btn-primary js-btn-loadable"
    end
  end

  def ui_box
    content_tag(:div, class: 'box box-solid') do
      content_tag(:div, class: 'box-body') { yield }
    end
  end
end
