module Admin::SitrackChildrenHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    SitrackChild.scaffold_columns
  end

end
