module ApplicationHelper
  def contact_us(text:)
    content_tag(:a, text, href: "mailto:contact@ultimate-tournament.io")
  end
end
