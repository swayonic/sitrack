class SitrackForm < ActiveRecord::Base
  belongs_to :hr_si_application, :foreign_key => :application_id
  belongs_to :approver
end
