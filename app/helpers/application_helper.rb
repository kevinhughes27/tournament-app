module ApplicationHelper
  def react_element(klass, props: nil, **kwargs)
    data = {react_class: klass.to_s}
    data[:react_props] = props.to_json if props
    content_tag(:div, '', data: data, **kwargs)
  end
end
