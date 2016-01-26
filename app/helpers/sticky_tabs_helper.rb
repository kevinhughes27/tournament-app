module StickyTabsHelper

  def tabs(**options, &block)
    TabsComponent.new(self, **options).render(&block)
  end

  class TabsComponent < SimpleDelegator
    attr_reader :key

    def initialize(view_context, key: '')
      @key = key
      super(view_context)
    end

    def nav(tabs)
      content_tag(:div, class: "nav-tabs-custom") do
        content_tag(:ul, class: "nav nav-tabs") do
          output = ''.html_safe
          tabs.each { |t| output += tab_nav(t) }
          output
        end
      end
    end

    def panes(&block)
      content_tag(:div, class: "tab-content") { capture(self, &block) }
    end

    def pane(name, &block)
      klass = 'tab-pane'
      klass += ' active' if active_tab?(name)
      content_tag(:div, id: name.underscore, class: klass) { capture(self, &block) }
    end

    def render(&block)
      capture(self, &block)
    end

    private

    def tab_nav(name)
      klass = active_tab?(name) ? 'active' : ''

      content_tag(:li, class: klass) do
        content_tag(:a,
          name.titleize,
          href: "##{name.underscore}",
          'data-toggle' => 'tab'
        )
      end
    end

    def active_tab?(name)
      request.cookies[key] == "##{name.underscore}"
    end
  end
end
