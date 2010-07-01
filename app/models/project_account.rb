require 'pdfkit'

class ProjectAccount
  include ActionView::Helpers::NumberHelper
  attr_reader :project
  
  def initialize( project )
    @project = project
    @line_items = nil
  end
  
  def line_items
    @line_items || line_items!
  end
  
  def line_items!
    @line_items = LineItem.for_project(project)
    balance = 0.0
    @line_items.each do |line_item|
      line_item.balance = (balance += line_item.amount)
    end
    @line_items
  end
  
  def line_items_statement
    result = []
    line_items.reverse_each do |line_item|
      next if line_item.future?
      break if line_item.balance == 0.0 and line_item != line_items.last
      result << line_item
      break if line_item.balance < 0.0
    end
    result.reverse!
  end
  
  def pdf_statement(amount_due = 0.0)
    ProjectAccountStatement.new(self, @project, amount_due)
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
