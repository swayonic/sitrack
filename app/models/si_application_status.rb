class SiApplicationStatus
  def self.all
    [['started','Applicant'], 
		 ['submitted','Submitted'],
		 ['completed','Ready'],
		 ['being_evaluated','Being Evaluated'],
		 ['pre_a','Pre A'],
		 ['accepted','Accepted'],
		 ['follow_through','Follow Through'],
		 ['placed','Placed'],
		 ['on_assignment','On Assignment'],
		 ['declined','Declined'],
		 ['withdrawn','Withdrawn'],
		 ['alumni','Alumni'],
		 ['re_applied','Re-Applied'],
		 ['terminated','Terminated']]
  end
end