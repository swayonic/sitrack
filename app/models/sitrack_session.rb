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
