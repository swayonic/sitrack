class AddFormMailer < ActionMailer::Base
  def form_email(to, var_hash, form_html)
    @subject = 'Add Form for '+var_hash['person'].full_name
    from_name = var_hash['approver'].full_name
    from_address = var_hash['approver'].current_address.email
    @from = "#{from_name} <#{from_address}>"
    @cc = @from
    @recipients = to
    @body = var_hash
    part :content_type => "text/html",
        :body => render_message("form_email", @body)
    attachment "text/html" do |a|
      a.filename = "Add Form.html" 
      a.body = form_html
      a.transfer_encoding = '7bit'
    end
  end
end
