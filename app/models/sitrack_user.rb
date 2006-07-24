class SitrackUser < ActiveRecord::Base
  has_many                  :sitrack_views, :dependent => true
  has_one                   :sitrack_session, :dependent => true
  belongs_to                :user, :foreign_key => :ssm_id
end
