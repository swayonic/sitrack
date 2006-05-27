require 'ajax_scaffold'

class SitrackColumn < ActiveRecord::Base
  set_primary_key           :colID
  has_and_belongs_to_many   :sitrack_views
end
