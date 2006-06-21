require 'ajax_scaffold'

class SitrackUser < ActiveRecord::Base
  has_many                  :sitrack_views
  belongs_to                :simplesecuritymanager_user, :foreign_key => :ssm_id
end
