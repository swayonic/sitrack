require 'ajax_scaffold'

class SitrackView < ActiveRecord::Base
  set_primary_key           :viewID
  has_and_belongs_to_many   :sitrack_columns
end
