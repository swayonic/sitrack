class FormMailer < ActionMailer::Base
  
  def add_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackAddForm.prepare(current_user, form))
    prepare_and_send_email('add_form')
  end

  def salary_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackSalaryForm.prepare(current_user, form))
    prepare_and_send_email('salary_form')
  end
  
  def additional_salary_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackAdditionalSalaryForm.prepare(current_user, form))
    extract_values(SitrackAdditionalSalaryForm.add_tax(form))
    prepare_and_send_email('additional_salary_form')
  end
  
  def acos_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackAcosForm.prepare(current_user, form))
    extract_values(SitrackAcosForm.setup_action(@form))
    prepare_and_send_email('acos_form')
  end
  
  def join_staff_form(current_user, form, to, form_type)
    @recipients = to
    extract_values(SitrackJoinStaffForm.prepare(current_user, form))
    prepare_and_send_email('join_staff_form')
  end
  
  private
  
  def prepare_and_send_email(type)
    @subject = "#{@form_title.titleize} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @body = "#{@subject} attached."
    attachment_content = render_to_string "form_mailer/#{type}", :layout => false
    attachments["#{Date.today.strftime('%Y-%m-%d')} #{@form_title.titleize} Form - #{@person.full_name.titleize}.html"] = attachment_content
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject, body: @body)
  end
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
  
  
end
