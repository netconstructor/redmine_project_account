class LineItemsController < ApplicationController
  unloadable
  
  helper_method :project, :project_account
  
  def index
    @line_items = project_account.line_items
    @line_item = LineItem.new(:project => project)
    respond_to do |wants|
      wants.html {}
      # TODO CSV export wants.csv { render :text => 'foo'} 
    end
  end
  
  def statement
    @line_items = project_account.line_items_statement
    respond_to do |wants|
      wants.html {}
      wants.pdf do
        statement = if params[:amount_due] == 'true'
            project_account.pdf_statement(true)
          elsif params[:amount_due]
            project_account.pdf_statement(params[:amount_due].to_f)
          else
            project_account.pdf_statement
          end
        send_data statement.to_pdf, :filename => statement.filename, 
                                    :type => "application/pdf"
      end
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
end
