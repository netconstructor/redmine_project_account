require 'redmine'

Redmine::Plugin.register :redmine_project_account do
  name 'Redmine Project Account plugin'
  author 'Travis Warlick'
  description 'Manage a monetary account for a project.'
  version '0.0.0'
  
  project_module :accounts do
    permission :view_account, :line_items => ['index', 'statement']
    permission :edit_account, :line_items => ['edit', 'update', 'create', 'destroy']
  end
  
  menu :project_menu, :account, { :controller => 'line_items', :action => 'index' }, :caption => 'Account', :after => :overview, :param => :project_id
  gem 'pdfkit'
end
