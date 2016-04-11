module SidebarHelper
  def sidebar_class
    request.cookies['sidebar']
  end

  def sidebar_menu_class(name)
    'active' if request.cookies['sidebar-menu'] == name
  end

  def games_badge(tournament)
    count = tournament.games.reported_unconfirmed.count
    if count > 0
      content_tag(:span, count, id: 'games-badge', class: 'badge pull-right')
    else
      nil
    end
  end

  def sidebar_link(icon, text, path, options = {})
    badge = options.delete(:badge)
    content_tag :li do
      content_tag :a, options.merge(class: 'sidebar-link', href: path) do
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
