# == Schema Information
# Schema version: 17
#
# Table name: sitrack_forms
#
#  id                              :integer(11)   not null, primary key
#  approver_id                     :integer(10)   default(0), not null
#  type                            :string(50)    default(), not null
#  current_years_salary            :integer(11)   
#  previous_years_salary           :integer(11)   
#  additional_salary               :integer(11)   
#  adoption                        :integer(11)   
#  counseling                      :integer(11)   
#  childrens_expenses              :integer(11)   
#  college                         :integer(11)   
#  private_school                  :integer(11)   
#  graduate_studies                :integer(11)   
#  auto_purchase                   :integer(11)   
#  settling_in_expenses            :integer(11)   
#  reimbursable_expenses           :integer(11)   
#  tax_rate                        :integer(11)   
#  date_of_change                  :datetime      
#  action                          :string(255)   
#  reopen_as                       :string(50)    
#  freeze_start                    :datetime      
#  freeze_end                      :datetime      
#  change_assignment_from_team     :string(50)    
#  change_assignment_from_location :string(50)    
#  change_assignment_to_team       :string(50)    
#  change_assignment_to_location   :string(50)    
#  restint_location                :string(50)    
#  departure_date_certainty        :string(20)    
#  hours_per_week                  :integer(11)   
#  other_explanation               :string(255)   
#  new_staff_training_date         :datetime      
#  payroll_action                  :string(50)    
#  payroll_reason                  :string(50)    
#  hrd                             :string(100)   
#  spouse_name                     :string(100)   
#  spouse_transitioning            :boolean(1)    
#  salary_reason                   :string(255)   
#  annual_salary                   :integer(11)   
#  hr_si_application_id            :integer(11)   default(0), not null
#

class SitrackAddForm < SitrackForm

  def validate
    errors.add_on_empty('First Name') if hr_si_application.person.firstName.empty?
    errors.add_on_empty('Last Name') if hr_si_application.person.lastName.empty?
    errors.add_on_empty('Birth Date') if hr_si_application.person.birth_date.nil?
    errors.add_on_empty('SSN') if hr_si_application.ssn.blank?
    errors.add_on_empty('Secure Employee') if !['T','F'].include?(hr_si_application.person.isSecure)
    errors.add_on_empty('Sending Region') if hr_si_application.sitrack_tracking.regionOfOrigin.blank?
    errors.add_on_empty('Caring Region') if hr_si_application.sitrack_tracking.caringRegion.blank?
    errors.add_on_empty('Department') if hr_si_application.sitrack_tracking.asgTeam.blank?
    errors.add_on_empty('Strategy') if hr_si_application.sitrack_tracking.sendLane.blank?
    errors.add_on_empty('Sending Department') if hr_si_application.sitrack_tracking.send_dept.blank?
    errors.add_on_empty('Current Address', 'must be completely filled out') if hr_si_application.person.current_address.nil? || hr_si_application.person.current_address.address1.blank?
    errors.add_on_empty('Permanent Address', 'must be completely filled out') if hr_si_application.person.permanent_address.nil? || hr_si_application.person.permanent_address.address1.blank?
    errors.add_on_empty('Emergency Address', 'must be completely filled out') if hr_si_application.person.emergency_address1.nil? || hr_si_application.person.emergency_address1.address1.blank?
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
