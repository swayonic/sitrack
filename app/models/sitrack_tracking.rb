require 'ajax_scaffold'

class SitrackTracking < ActiveRecord::Base
  belongs_to                :si_application, :foreign_key => 'application_id'
end
