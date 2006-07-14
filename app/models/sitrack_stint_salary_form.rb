class SitrackStintSalaryForm < SitrackSalaryForm
  def validate
    super
    errors.add_on_empty('AOA') if hr_si_application.sitrack_tracking.asgContinent.nil? || hr_si_application.sitrack_tracking.asgContinent.empty?
    errors.add_on_empty('Country') if hr_si_application.sitrack_tracking.asgCountry.nil? || hr_si_application.sitrack_tracking.asgCountry.empty?
  end
  
  def tax_rate
    18
  end
end
