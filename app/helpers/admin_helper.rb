module AdminHelper

  def admin_content_box(&block)
    content_tag(:section, class: "content") do
      content_tag(:div, class: "box") do
        content_tag(:div, class: "box-body") { yield }
      end
    end
  end

end
