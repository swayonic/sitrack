# == Schema Information
# Schema version: 17
#
# Table name: sitrack_users
#
#  id         :integer(10)   not null, primary key
#  ssm_id     :integer(11)   
#  last_login :datetime      
#  created_at :datetime      not null
#  created_by :integer(10)   default(0), not null
#  updated_at :datetime      not null
#  updated_by :integer(10)   default(0), not null
#

class SitrackUser < ActiveRecord::Base
  has_many                  :sitrack_views, :dependent => :destroy
  has_one                   :sitrack_session, :dependent => :destroy
  belongs_to                :user, :foreign_key => :ssm_id
end
