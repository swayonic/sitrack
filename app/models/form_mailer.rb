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
  
end
