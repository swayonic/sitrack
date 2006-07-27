# == Schema Information
# Schema version: 17
#
# Table name: sitrack_enum_values
#
#  id                :integer(10)   not null, primary key
#  sitrack_column_id :integer(10)   default(0), not null
#  value             :string(100)   default(), not null
#  name              :string(100)   default(), not null
#  position          :integer(10)   
#

class SitrackEnumValue < ActiveRecord::Base
end
