# == Schema Information
# Schema version: 17
#
# Table name: sitrack_mpd
#
#  id             :integer(10)   not null, primary key
#  application_id :integer(10)   
#  person_id      :integer(10)   
#  coachName      :string(50)    
#  coachPhone     :string(20)    
#  coachCell      :string(20)    
#  coachEmail     :string(50)    
#  monthlyGoal    :integer(10)   
#  oneTimeGoal    :integer(10)   
#  monthlyRaised  :integer(10)   
#  oneTimeRaised  :integer(10)   
#  totalGoal      :integer(10)   
#  totalRaised    :integer(10)   
#  percentRaised  :integer(10)   
#  created_at     :datetime      
#  updated_at     :datetime      
#  goalYear       :string(4)     
#  salary         :integer(10)   
#

class SitrackMpd < ActiveRecord::Base
end
