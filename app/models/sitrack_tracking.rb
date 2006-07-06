require 'ajax_scaffold'

class SitrackTracking < ActiveRecord::Base
  belongs_to                :si_application, :foreign_key => 'application_id'
  
  def is_stint?
    return true if ['ICS','STINT'].include?(internType)
    return false
  end
end
