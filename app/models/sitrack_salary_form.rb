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

class SitrackSalaryForm < SitrackForm
  
  attr_accessible :date_of_change, :salary_reason, :annual_salary, :additional_notes
  
  def validate
    errors.add_on_empty('Account #') if hr_si_application.person.accountNo.empty?
    errors.add_on_empty('SSN') if hr_si_application.ssn.empty?
    errors.add_on_empty('Birth Date') if hr_si_application.person.birth_date.nil?
    errors.add_on_empty('Hire Date (Effective Date of Change)') if date_of_change.nil? || date_of_change.to_s.empty?
    errors.add_on_empty('City') if hr_si_application.sitrack_tracking.nil? || hr_si_application.sitrack_tracking.asgCity.nil? || hr_si_application.sitrack_tracking.asgCity.empty?
    errors.add('New Annual Base Salary (Net)', 'must be a number') if annual_salary.nil? || annual_salary.to_i == 0
    super
  end 
  
  def email(current_user, form_type)
    extract_values(SitrackSalaryForm.prepare(current_user, self))
    email = FormMailer.salary_form(current_user, @form, to, form_type).deliver!
    
    # Stamp "form submitted" column
    @tracking.addForm = Time.now
    @tracking.save!
  end
  
  def self.prepare(current_user, form)
    
    @form = form
    @form_title = 'Salary'
    @application = @form.hr_si_application
    @person = @application.person
    
    @current_address = @person.current_address || CurrentAddress.create(:person_id => @person.id)
    @tracking = @application.sitrack_tracking || SitrackTracking.new
    @tracking.asgCity  = @current_address.city if @tracking.asgCity.nil? || @tracking.asgCity.empty?
    @tracking.asgState  = @current_address.state if @tracking.asgState.nil? || @tracking.asgState.empty?
    @tracking.asgCountry  = @current_address.country if @tracking.asgCountry.nil? || @tracking.asgCountry.empty?
    @mpd = @application.sitrack_mpd || SitrackMpd.new
    @approver = @form.approver = current_user.person
    # If current date is >= 5th and <= 20th, put the 16th. Else put 1st
    day = Time.now.day
    month = Time.now.month
    year = Time.now.year
  	if (day >= 5 && day <= 20) 
  		date = Time.local(year, month, 16)
  	elsif (day > 20)
  	  month = month+1
      year += 1 if month == 13
      month = 1 if month == 13
  		date = Time.local(year, month, 1)
  	else
  		date = Time.local(year, month, 1)
  	end
    @form.date_of_change ||= date
    @form.annual_salary ||= @mpd.salary.to_i * 12 if @mpd.salary
    
    var_hash = Hash.new
    var_hash['form_title'] = @form_title
    var_hash['form'] = @form
    var_hash['application'] = @application
    var_hash['person'] = @person
    var_hash['current_address'] = @current_address
    var_hash['mpd'] = @mpd
    var_hash['tracking'] = @tracking
    var_hash['approver'] = @approver
    
    return var_hash
  end
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
end
