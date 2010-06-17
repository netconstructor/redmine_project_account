class LineItemsController < ApplicationController
  unloadable
  
  helper_method :project, :project_account
  
  def index
    find_line_items
    @line_item = LineItem.new(:project => project)
    respond_to do |wants|
      wants.html {}
      # TODO CSV export wants.csv { render :text => 'foo'} 
      # TODO PDF export wants.pdf { render :text => 'foo'}
    end
  end

  def create
    @line_item = LineItem.new(params[:line_item].reverse_merge(:project => project))
    if @line_item.save
      flash[:notice] = 'Line item added'
      redirect_to :action => 'index', :project_id => project.id
    else
      flash.now[:error] = @line_item.errors.full_messages.join(', ')
      find_line_items
      render :action => 'index'
    end
  end

  def edit
    @line_item = LineItem.for_project(project).find(params[:id])
  end

  def update
    @line_item = LineItem.for_project(project).find(params[:id])
  end

  def destroy
    @line_item = LineItem.for_project(project).find(params[:id])
    @line_item.destroy
    flash[:notice] = "Line item deleted."
    redirect_to :action => 'index', :project_id => project.id
  end
  
  private
  
  def project
    @project ||= Project.find(params[:project_id] || params[:line_item][:project_id])
  end
  
  def project_account
    @project_account||= ProjectAccount.new(project)
  end
  
  def find_line_items
    @line_items = ProjectAccount.new(project).line_items
  end
end
