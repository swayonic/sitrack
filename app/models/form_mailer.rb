class FormMailer < ActionMailer::Base
  
  def join_staff_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackJoinStaffForm.prepare(current_user, form))
    prepare_and_send_email
  end
  
  def additional_salary_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackAdditionalSalaryForm.prepare(current_user, form))
    extract_values(SitrackAdditionalSalaryForm.add_tax(form))
    prepare_and_send_email
  end

  def salary_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackSalaryForm.prepare(current_user, form))
    prepare_and_send_email
  end
  
  def add_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackAddForm.prepare(current_user, form))
    prepare_and_send_email
  end
  
  def acos_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackAcosForm.prepare(current_user, form))
    extract_values(SitrackAcosForm.setup_action(@form))
    prepare_and_send_email
  end
  
  private
  
  def prepare_and_send_email
    @subject = "#{@form_title} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject) 
  end
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
  
  
end
