# == Schema Information
# Schema version: 17
#
# Table name: sitrack_queries
#
#  id         :integer(10)   not null, primary key
#  name       :string(50)    default(), not null
#  owner      :integer(10)   default(0), not null
#  persons    :text          default(), not null
#  created_at :datetime      not null
#  updated_at :datetime      not null
#

class SitrackQuery < ActiveRecord::Base
end
