module WillShip
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_show_description_bottom(context)
      controller = context[:controller]

      controller.render_to_string({:partial => 'hooks/will_ship/view_issues_show_description_bottom', :locals => context})
    end

    def view_layouts_base_html_head(context)
      stylesheet_link_tag('will_ship.css', :plugin => 'will_ship')
    end
  end
end
