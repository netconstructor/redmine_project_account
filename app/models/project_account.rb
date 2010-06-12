class ProjectAccount
  attr_reader :project
  
  def initialize( project )
    @project = project
  end
  
  def line_items
    @line_items ||= LineItem.for_project(project)
  end
  
  def future_items?
    line_items.any? and line_items.last.future?
  end
  
  def current_balance
    LineItem.project_balance_to_date(project)
  end
  
  def final_balance
    LineItem.project_balance(project)
  end
  
  def project_self_and_descendants_ids
    project.self_and_descendants.find(:all, :select => 'id').collect(&:id)
  end
end
