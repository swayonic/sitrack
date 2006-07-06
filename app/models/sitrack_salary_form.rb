class SitrackSalaryForm < SitrackForm
  def validate
    errors.add_on_empty('Account #') if hr_si_application.person.accountNo.empty?
    errors.add_on_empty('SSN') if hr_si_application.ssn.empty?
    errors.add_on_empty('Birth Date') if hr_si_application.person.birthDate.nil? || hr_si_application.person.birthDate.empty?
    errors.add_on_empty('Hire Date (Effective Date of Change)') if date_of_change.nil? || date_of_change.empty?
    errors.add_on_empty('City') if hr_si_application.tracking.asgCity.nil? || hr_si_application.tracking.asgCity.empty?
    errors.add_on_empty('Country') if hr_si_application.tracking.asgCountry.nil? || hr_si_application.tracking.asgCountry.empty?
    errors.add_on_empty('Continent') if hr_si_application.tracking.asgContinent.nil? || hr_si_application.tracking.asgContinent.empty?
    errors.add_on_empty('New Annual Base Salary (Net)') if annual_salary.nil? || annual_salary.empty?
    super
  end 
  
  def email(var_hash, form_html)
    to = 'Josh Starcher <josh.starcher@uscm.org>'
    email = AddFormMailer.create_form_email(to, var_hash, form_html)
    AddFormMailer.deliver(email)
  end
end