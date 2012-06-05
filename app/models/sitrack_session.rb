# == Schema Information
# Schema version: 17
#
# Table name: sitrack_sessions
#
#  id              :integer(10)   not null, primary key
#  sitrack_user_id :integer(10)   default(0), not null
#  created_at      :datetime      not null
#

class SitrackSession < ActiveRecord::Base
  unloadable
  
  attr_accessible :sitrack_user_id
  
  has_many  :sitrack_session_values, :dependent => :destroy
  
  
  def save_value(attrib, value)
    remove_value(attrib)
    sitrack_session_values << SitrackSessionValue.new(:attrib => attrib, :value => value)
  end
  
  def remove_value(attrib)
    SitrackSessionValue.delete_all(["sitrack_session_id = ? AND attrib = ?", id, attrib])
  end
  
  def get_value(attrib)
    session_value = sitrack_session_values.find_by_attrib(attrib)
    session_value ? session_value.value : nil
  end
end
