module SidebarHelper
  def sidebar_class
    request.cookies['sidebar']
  end

  def sidebar_user_class
    'display: none;' if sidebar_class.present?
  end

  def sidebar_menu_class(name)
    'active' if request.cookies['sidebar-menu'] == name
  end

  def sidebar_link(icon, text, path, options = {})
    content_tag :li do
      content_tag :a, options.merge(href: path) do
        content_tag(:i, '', class: icon) +
        content_tag(:span, text)
      end
    end
  end
end
