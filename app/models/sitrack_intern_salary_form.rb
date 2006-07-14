class SitrackInternSalaryForm < SitrackSalaryForm
  def validate
    super
    errors.add_on_empty('State') if hr_si_application.sitrack_tracking.asgState.nil? || hr_si_application.sitrack_tracking.asgState.empty?
    errors.add('You must specify the <strong>Type of Form</strong>') if payroll_action.nil? || payroll_action.empty?
  end
end
