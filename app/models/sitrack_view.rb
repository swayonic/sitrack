require 'ajax_scaffold'

class SitrackView < ActiveRecord::Base
  has_many   :sitrack_view_columns, :order => :position, :include => :sitrack_column, :dependent => true
  has_many   :sitrack_columns, :through => :sitrack_view_columns
  belongs_to :sitrack_user
    
  validates_presence_of :name
  
  def display_columns
    out = Person.table_name+'.personID as id, '+SiApplication.table_name+'.applicationID, '
    out += '(SELECT email FROM '+Address.table_name+' WHERE fk_personID = '+Person.table_name+".personID AND addressType = 'current') as email, "
    sitrack_view_columns.each do |vc|
      column = vc.sitrack_column
      out += column.table
      out += column.select_clause+ ' as ' +column.safe_name
      out += ', ' unless vc == sitrack_view_columns.last
    end
    return out
  end
  
  def self.join_tables
    out = Person.table_name
    out += " JOIN #{SiApplication.table_name} on #{Person.table_name}.personID = #{SiApplication.table_name}.fk_personID "
    out += " LEFT JOIN #{Staff.table_name} on #{Person.table_name}.accountNo = #{Staff.table_name}.accountNo "
    out += " LEFT JOIN #{SitrackMpd.table_name} on #{SiApplication.table_name}.applicationID = #{SitrackMpd.table_name}.application_id "
    out += " LEFT JOIN #{SitrackTracking.table_name} on #{SiApplication.table_name}.applicationID = #{SitrackTracking.table_name}.application_id "
    return out
  end
  
  # returns an array of tables needed for this view
  def tables
    @tables = []
    sitrack_view_columns.each do |vc|
      column = vc.sitrack_column
      column.table_clause.split(',').each  do |table|
        @tables << table  unless @tables.include?(table)
      end
    end
    return @tables
  end
  
  def safe_column_names
    names = []
    sitrack_view_columns.each { |vc| names << vc.sitrack_column.safe_name if vc.sitrack_column }
    return names
  end
end
