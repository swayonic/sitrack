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
  has_many  :sitrack_session_values, :dependent => true
  
  def save_value(attribute, value)
    remove_value(attribute)
    sitrack_session_values << SitrackSessionValue.new(:attribute => attribute, :value => value)
  end
  
  def remove_value(attribute)
    SitrackSessionValue.delete_all(["sitrack_session_id = ? AND attribute = ?", id, attribute])
  end
  
  def get_value(attribute)
    session_value = sitrack_session_values.find_by_attribute(attribute)
    session_value ? session_value.value : nil
  end
end
