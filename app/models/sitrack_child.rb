# == Schema Information
# Schema version: 17
#
# Table name: sitrack_children
#
#  id          :integer(10)   not null, primary key
#  name        :string(50)    
#  birthday    :datetime      
#  passport_no :string(50)    
#  person_id   :integer(10)   default(0), not null
#

class SitrackChild < ActiveRecord::Base
  belongs_to    :person
  
  validates_presence_of :name
  validates_presence_of :birthday
end
