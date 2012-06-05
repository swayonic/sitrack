# == Schema Information
# Schema version: 17
#
# Table name: sitrack_saved_criteria
#
#  id         :integer(10)   not null, primary key
#  name       :string(50)    default(), not null
#  owner      :integer(10)   default(0), not null
#  criteria   :text          default(), not null
#  saved      :integer(3)    default(0), not null
#  options    :text          default(), not null
#  created_at :datetime      not null
#  updated_at :datetime      
#

class SitrackSavedCriteria < ActiveRecord::Base
  attr_accessible :owner, :criteria, :options
end
