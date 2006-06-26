class SitrackChild < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :birthday
end
