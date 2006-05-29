require 'ajax_scaffold'

class SitrackUser < ActiveRecord::Base
  set_primary_key           :ssm_id
  has_many                  :sitrack_views, :foreign_key => :ssm_id
end
