class LineItem < ActiveRecord::Base
  belongs_to :project
  
  validates_presence_of :project, :description, :amount, :date
  
  validates_length_of :description, :maximum => 200
  validates_numericality_of :amount
  
  named_scope :for_project, lambda {|p| {:conditions => ["project_id IN(#{ProjectAccount.new(p).project_self_and_descendants_ids.join(',')})"], 
                                         :order => 'date ASC, amount DESC'} }
  
  def self.project_balance( project )
    for_project(project).sum(:amount)
  end
  
  def self.project_balance_to_date( project )
    for_project(project).sum(:amount, :conditions => ['date <= ?', Date.today])
  end

  def future?
    date > Date.today
  end
  
  def credit?
    amount < 0.0
  end
end
