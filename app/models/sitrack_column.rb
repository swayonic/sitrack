require 'ajax_scaffold'

class SitrackColumn < ActiveRecord::Base
  has_many   :sitrack_view_columns
  has_many   :sitrack_views, :through => :sitrack_view_columns
  has_many   :sitrack_enum_values
  
  cattr_reader :all_columns
  def safe_name
    name.gsub(' ','_')
  end
  
  def self.all_select_clauses
    @@all_columns = self.find(:all) if !@@all_columns
    select_clauses = []
    @@all_columns.each {|column| select_clauses << column.select_clause+' as '+column.safe_name }
    return select_clauses.join(', ')
  end
  
  def table
    if (table_clause && table_clause.length != 0)
      return eval(table_clause.split(',')[0]+'.table_name')+'.' 
    else 
      return ''
    end
  end
end
