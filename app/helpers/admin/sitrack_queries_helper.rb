module Admin::SitrackQueriesHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    SitrackQuery.scaffold_columns
  end

end
