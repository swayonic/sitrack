class SitrackViewColumn < ActiveRecord::Base
  belongs_to  :sitrack_view
  belongs_to  :sitrack_column
  acts_as_list :scope => :sitrack_view
end
