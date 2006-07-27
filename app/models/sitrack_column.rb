# == Schema Information
# Schema version: 17
#
# Table name: sitrack_columns
#
#  id                :integer(10)   not null, primary key
#  name              :string(30)    default(), not null
#  column_type       :string(20)    default(), not null
#  select_clause     :string(7000)  default(), not null
#  where_clause      :string(255)   
#  update_clause     :string(255)   
#  table_clause      :string(100)   
#  show_in_directory :integer(3)    default(1), not null
#  writeable         :integer(3)    default(1), not null
#  created_at        :datetime      
#  updated_at        :datetime      
#

class SitrackColumn < ActiveRecord::Base
  has_many   :sitrack_view_columns
  has_many   :sitrack_views, :through => :sitrack_view_columns
  has_many   :sitrack_enum_values, :order => :position
  
  cattr_reader :all_columns
  def safe_name
    name.gsub(' ','_')
  end
  
  def self.all_select_clauses
    @@all_columns = self.find(:all) if !@@all_columns
    select_clauses = []
    @@all_columns.each do |column| 
      if column
        table = '(' == column.select_clause.first ? '' : column.table
        select_clauses << table + column.select_clause+' as '+column.safe_name 
      end
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
