class SitrackAdditionalSalaryForm < SitrackForm
  def email(var_hash, form_html)
    to = 'Josh Starcher <josh.starcher@uscm.org>'
    email = FormMailer.create_form_email(to, var_hash, form_html, 'Additional Salary Form')
    FormMailer.deliver(email)
    
    # Stamp "form submitted" column
    var_hash['tracking'].additionalSalaryForm = Time.now
    var_hash['tracking'].save!
  end
end
