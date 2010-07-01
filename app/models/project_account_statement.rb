class ProjectAccountStatement
  TEMPLATE_DIR = File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'lib', 'project_account_statement')
  include ERB::Util
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  
  attr_reader :project_account
  attr_reader :project
  attr_reader :amount_due
  
  def initialize(project_account, project, amount_due = 0.0)
    @project_account = project_account
    @project = project
    @amount_due = (amount_due == true ? project_account.current_balance : amount_due)
    @amount_due = 0.0 if @amount_due < 0.0
  end
  
  def to_pdf
    pdf_kit = PDFKit.new(run_template, pdf_kit_options)
    stylesheets.each { |s| pdf_kit.stylesheets << s }
    pdf_kit.to_pdf
  end
  
  def filename
    %(statement-#{project.identifier}-#{Date.today.strftime}.pdf)
  end
  
  private
  
  def stylesheets
    Dir.glob(File.join(TEMPLATE_DIR, '*.css')).to_a.sort
  end
  
  def template_file
    File.join(TEMPLATE_DIR, 'template.html.erb')
  end
  
  def run_template
    template = ERB.new(File.read(template_file))
    template.result(binding)
  end
  
  def pdf_kit_options(overrides = {})
    {
      :page_size        => 'Letter',
      :margin_top       => '0.5in',
      :margin_bottom    => '0.5in',
      :margin_left      => '0.5in',
      :margin_right     => '0.5in'
    }.merge(overrides)
  end
end
