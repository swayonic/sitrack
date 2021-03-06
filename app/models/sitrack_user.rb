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
  unloadable
  
  attr_accessible :ssm_id, :created_by, :updated_by
  has_many                  :sitrack_views, :dependent => :destroy
  has_one                   :sitrack_session, :dependent => :destroy
  belongs_to                :user, :foreign_key => :ssm_id

  def create_views
    SitrackView.transaction do
      SitrackView.find_all_by_sitrack_user_id(0).each do |view|
        new_view = sitrack_views.create(name: view.name)
        view.sitrack_view_columns.each do |vc|
          new_view.sitrack_view_columns << vc.clone
        end
      end
      save
    end
  end
end
