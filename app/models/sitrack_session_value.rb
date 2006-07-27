# == Schema Information
# Schema version: 17
#
# Table name: sitrack_session_values
#
#  id                 :integer(10)   not null, primary key
#  sitrack_session_id :integer(10)   default(0), not null
#  attribute          :string(50)    default(), not null
#  value              :string(255)   default(), not null
#

class SitrackSessionValue < ActiveRecord::Base
  belongs_to  :sitrack_session
end
