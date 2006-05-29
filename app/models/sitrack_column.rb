require 'ajax_scaffold'

class SitrackColumn < ActiveRecord::Base
  has_many   :sitrack_view_columns
  has_many   :sitrack_views, :through => :sitrack_view_columns
end
