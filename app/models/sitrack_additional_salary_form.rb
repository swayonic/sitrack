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

class SitrackAdditionalSalaryForm < SitrackForm
  
  attr_accessible :hr_si_application_id, :current_years_salary, :previous_years_salary, :additional_salary,
    :adoption, :counseling, :childrens_expenses, :college, :private_school, :graduate_studies, 
    :auto_purchase, :settling_in_expenses, :reimbursable_expenses, :tax_rate, :healthcare
  
  def to
    if hr_si_application.sitrack_tracking.is_stint?
      'Celeste Allison <celeste.allison@ccci.org>'
    else
      'Susan Palocin <susan.palocin@ccci.org>'
    end
  end
  
  def email(current_user)
    extract_values(SitrackAdditionalSalaryForm.prepare(current_user, self))
    
    email = FormMailer.additional_salary_form(current_user, @form, to, @form_title).deliver!
    
    # Stamp "form submitted" column
    @tracking.additionalSalaryForm = Time.now
    @tracking.save!
  end
  
  def self.prepare(current_user, form)
    
    @form = form
    @form_title = 'Additional Salary'
    @application = @form.hr_si_application
    @person = @application.person
    @current_address = (@person.current_address || Address.new)
    @approver = @form.approver = current_user.person
    @tracking = @application.sitrack_tracking
    
    var_hash = Hash.new
    var_hash['form'] = @form
    var_hash['form_title'] = @form_title
    var_hash['application'] = @application
    var_hash['person'] = @person
    var_hash['current_address'] = @current_address
    var_hash['approver'] = @approver
    var_hash['tracking'] = @tracking
    
    return var_hash
  end
  
  def self.add_tax(form)
    columns = %w{current_years_salary previous_years_salary additional_salary adoption
                counseling childrens_expenses college private_school graduate_studies auto_purchase
                settling_in_expenses reimbursable_expenses healthcare}
    @total = 0
    var_hash = Hash.new
    columns.each do |c|
      amount = form[c].to_i
      if amount != 0
        amount = (amount / (1-(form.tax_rate.to_f/100))).round 
        var_hash["#{c}_x"] = '[X]'
        @total += amount
      else
        var_hash["#{c}_x"] = '[&nbsp;&nbsp;]'
      end
    end
    var_hash["total"] = @total
    return var_hash
  end
  
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
  
  
  
  
  
end
