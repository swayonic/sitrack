# == Schema Information
# Schema version: 17
#
# Table name: sitrack_view_columns
#
#  id                :integer(10)   not null, primary key
#  sitrack_view_id   :integer(10)   default(0), not null
#  sitrack_column_id :integer(10)   default(0), not null
#  position          :integer(10)   default(0), not null
#

class SitrackViewColumn < ActiveRecord::Base
  
  attr_accessible :sitrack_view_id, :sitrack_column_id, :position
  
  belongs_to  :sitrack_view
  belongs_to  :sitrack_column
  acts_as_list :scope => :sitrack_view
end
