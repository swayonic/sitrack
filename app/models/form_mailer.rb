class FormMailer < ActionMailer::Base
  
  def form_email(to, var_hash, form_html, form_type)
    
    @subject = form_type + ' for '+var_hash['person'].full_name
    from_name = var_hash['approver'].full_name
    from_address = var_hash['approver'].email
    @from = "#{from_name} <#{from_address}>"
    @cc = @from
    @recipients = to
    @body = var_hash
    @body[:form_type] = form_type
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject, body: @body)
  end
  
  def join_staff_form(current_user, form, to, form_type)
    extract_values(SitrackJoinStaffForm.prepare(current_user, form))
    
    @subject = "#{form_type} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @recipients = to
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end
  
  def additional_salary_form(current_user, form, to, form_type)
    extract_values(SitrackAdditionalSalaryForm.prepare(current_user, form))
    extract_values(SitrackAdditionalSalaryForm.add_tax(form))
    
    @subject = "#{form_type} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @recipients = to
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end

  def salary_form(current_user, form, to, form_type)
    extract_values(SitrackSalaryForm.prepare(current_user, form))
    
    @subject = "#{form_type} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @recipients = to
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end
  
  def add_form(current_user, form, to, form_type)
    extract_values(SitrackAddForm.prepare(current_user, form))
    
    @subject = "#{form_type} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @recipients = to
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end
  
  def acos_form(current_user, form, to, form_type)
    extract_values(SitrackAcosForm.prepare(current_user, form))
    extract_values(SitrackAcosForm.setup_action(@form))
    
    @subject = "#{form_type} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @recipients = to
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject) 
  end
  
  private
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
end
