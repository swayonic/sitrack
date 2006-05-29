require 'ajax_scaffold'

class SitrackView < ActiveRecord::Base
  has_many   :sitrack_view_columns, :order => :position
  has_many   :sitrack_columns, :through => :sitrack_view_columns
end
