module Admin::SitrackColumnsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    SitrackColumn.scaffold_columns
  end

end
