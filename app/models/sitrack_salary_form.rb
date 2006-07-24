class SitrackSalaryForm < SitrackForm
  def validate
    errors.add_on_empty('Account #') if hr_si_application.person.accountNo.empty?
    errors.add_on_empty('SSN') if hr_si_application.ssn.empty?
    errors.add_on_empty('Birth Date') if hr_si_application.person.birth_date.nil?
    errors.add_on_empty('Hire Date (Effective Date of Change)') if date_of_change.nil? || date_of_change.to_s.empty?
    errors.add_on_empty('City') if hr_si_application.sitrack_tracking.nil? || hr_si_application.sitrack_tracking.asgCity.nil? || hr_si_application.sitrack_tracking.asgCity.empty?
    errors.add('New Annual Base Salary (Net)', 'must be a number') if annual_salary.nil? || annual_salary.to_i == 0
    super
  end 
  
  def email(var_hash, form_html)
    email = FormMailer.create_form_email(to, var_hash, form_html, 'Salary Form')
    FormMailer.deliver(email)
    
    # Stamp "form submitted" column
    var_hash['tracking'].salaryForm = Time.now
    var_hash['tracking'].save!
  end
end