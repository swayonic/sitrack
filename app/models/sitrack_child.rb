class SitrackChild < ActiveRecord::Base
  belongs_to    :person
  
  validates_presence_of :name
  validates_presence_of :birthday
end
