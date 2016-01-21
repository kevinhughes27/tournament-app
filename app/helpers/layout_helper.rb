module LayoutHelper
  def sidebar_link(icon, text, path)
    content_tag :li do
      content_tag :a, href: path do
        content_tag(:i, '', class: icon) +
        content_tag(:span, text)
      end
    end
  end

  def admin_content(&block)
    content_tag(:section, class: "content") do
      content_tag(:div, class: "box") do
        content_tag(:div, class: "box-body") { yield }
      end
    end
  end
end
