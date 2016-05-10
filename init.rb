require 'redmine'
require 'will_ship'
require 'will_ship/hooks'

require_dependency 'issue_patch'
require_dependency 'project_patch'

Issue.send(:include, IssuePatch)
Project.send(:include, ProjectPatch)

Redmine::Plugin.register :will_ship do
  name 'Will Ship Plugin'
  author 'Alexander Tsirel'
  description 'Way to say is ticket shipped or not'
  version '0.0.1'

  menu :admin_menu, :will_ship, {controller: :will_ship, action: 'configure'}, caption: 'Will Ship', last: true
end
