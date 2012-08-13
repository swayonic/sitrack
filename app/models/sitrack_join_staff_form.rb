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

class SitrackJoinStaffForm < SitrackForm
  
  attr_accessible :hr_si_application_id, :date_of_change, :new_staff_training_date, :payroll_action,
    :payroll_reason, :hrd, :spouse_name, :additional_notes
  
  def validate
    errors.add_on_empty('Effective Date of Change') if date_of_change.nil? || date_of_change.to_s.empty?
    errors.add_on_empty('Account Number') if hr_si_application.person.accountNo.nil? || hr_si_application.person.accountNo.empty?
    errors.add_on_empty('MPD Coach') if hr_si_application.sitrack_mpd.coachName.nil? || hr_si_application.sitrack_mpd.coachName.empty?
    errors.add_on_empty('Name of approving HRD') if hrd.nil? || hrd.empty?
    super
  end
  
  def to
      'Personel Records <personnel.records@ccci.org>'
  end
  
  def email(current_user)
    extract_values(SitrackJoinStaffForm.prepare(current_user, self))
    email = FormMailer.join_staff_form(current_user, @form, to, @form_title).deliver!
    
    # Stamp "form submitted" column
    @tracking.joinStaffForm = Time.now
    @tracking.save!
  end
  
  def self.prepare(current_user, form)
    
    @form = form
    @form_title = 'Join Staff'
    @options_hash = ApplicationController.get_option_hash
    @application = @form.hr_si_application
    @person = @application.person
    @current_address = @person.current_address || Address.new
    @tracking = @application.sitrack_tracking || SitrackTracking.new
    @spouse = @person.spouse || Person.new
    @form.spouse_name = @spouse.first_name
    @mpd = @application.sitrack_mpd || (@application.sitrack_mpd = SitrackMpd.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @approver = @form.approver = current_user.person
    
    var_hash = Hash.new
    var_hash['form_title'] = @form_title
    var_hash['form'] = @form
    var_hash['options_hash'] = @options_hash
    var_hash['application'] = @application
    var_hash['person'] = @person
    var_hash['current_address'] = @current_address
    var_hash['spouse'] = @spouse
    var_hash['mpd'] = @mpd
    var_hash['region'] = @region
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
