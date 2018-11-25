module InternalHelper
  def sidebar_link(icon, text, path, options = {})
    badge = options.delete(:badge)
    content_tag :li do
      content_tag :a, options.merge(href: path) do
        html = ''.html_safe
        html += content_tag(:i, '', class: icon)
        html += content_tag(:span, text)
        if badge
          html += ' '
          html += badge.html_safe
        end
        html
      end
    end
  end
end
