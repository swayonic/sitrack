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
    @@all_columns.each do |column| 
      table = '(' == column.select_clause.first ? '' : column.table
      select_clauses << table + column.select_clause+' as '+column.safe_name 
    end
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
