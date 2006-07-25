class SitrackForm < ActiveRecord::Base
  belongs_to :hr_si_application
  belongs_to :approver
  
  def to
    if hr_si_application.sitrack_tracking.is_stint?
      'Celeste Allison <celeste.allison@ccci.org>'
    else
      'Personel Records <personnel.records@ccci.org>'
    end
  end
  
  def validate
    errors.add_on_empty('First Name') if hr_si_application.person.firstName.empty?
    errors.add_on_empty('Last Name') if hr_si_application.person.lastName.empty?
  end
end
