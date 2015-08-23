module SidebarHelper

  def sidebar_link(icon, text, path, condition)
    path = '#' unless condition

    content_tag :li do
      content_tag :a, href: path do
        content_tag(:i, '', class: icon) +
        content_tag(:span, text)
      end
    end
  end

end
