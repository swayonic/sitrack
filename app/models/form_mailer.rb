class FormMailer < ActionMailer::Base
  def form_email(to, var_hash, form_html, form_type)
    @subject = form_type + ' for '+var_hash['person'].full_name
    from_name = var_hash['approver'].full_name
    from_address = var_hash['approver'].email
    @from = "<#{from_address}>"
    @cc = @from
    @recipients = to
    @body = var_hash
    # attachment "text/html" do |a|
    #   a.filename = var_hash['person'].lastName + ', ' + var_hash['person'].firstName + ' - ' + form_type + '.html'
    #   a.body = form_html
    #   a.transfer_encoding = '7bit'
    # end
    @body[:form_type] = form_type
  end
end
