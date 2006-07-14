class SitrackAdditionalSalaryForm < SitrackForm
  def email(var_hash, form_html)
    to = 'Josh Starcher <josh.starcher@uscm.org>'
    email = FormMailer.create_form_email(to, var_hash, form_html, 'Salary Form')
    FormMailer.deliver(email)
  end
end
