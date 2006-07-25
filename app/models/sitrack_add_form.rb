class SitrackAddForm < SitrackForm

  def validate
    errors.add_on_empty('First Name') if hr_si_application.person.firstName.empty?
    errors.add_on_empty('Last Name') if hr_si_application.person.lastName.empty?
    errors.add_on_empty('Birth Date') if hr_si_application.person.birth_date.nil?
    errors.add_on_empty('SSN') if hr_si_application.ssn.nil? || hr_si_application.ssn.empty?
    errors.add_on_empty('Sending Region') if hr_si_application.person.region.nil? || hr_si_application.person.region.empty?
    errors.add_on_empty('Current Address', 'must be completely filled out') if hr_si_application.person.current_address.nil? || hr_si_application.person.current_address.address1.empty?
    errors.add_on_empty('Permanent Address', 'must be completely filled out') if hr_si_application.person.permanent_address.nil? || hr_si_application.person.permanent_address.address1.empty?
    errors.add_on_empty('Emergency Address', 'must be completely filled out') if hr_si_application.person.emergency_address1.nil? || hr_si_application.person.emergency_address1.address1.empty?
    super
  end 
  
  def to
      'Personel Records <personnel.records@ccci.org>'
  end
  
  def email(var_hash, form_html)
    email = FormMailer.create_form_email(to, var_hash, form_html, 'Add Form')
    FormMailer.deliver(email)
    
    # Stamp "form submitted" column
    var_hash['tracking'].addForm = Time.now
    var_hash['tracking'].save!
  end
end
