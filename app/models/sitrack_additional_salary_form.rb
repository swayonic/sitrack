class SitrackAdditionalSalaryForm < SitrackForm
  def to
    if hr_si_application.sitrack_tracking.is_stint?
      'Celeste Allison <celeste.allison@ccci.org>'
    else
      'Susan Palocin <susan.palocin@ccci.org>'
    end
  end
  def email(var_hash, form_html)
    email = FormMailer.create_form_email(to, var_hash, form_html, 'Additional Salary Form')
    FormMailer.deliver(email)
    
    # Stamp "form submitted" column
    var_hash['tracking'].additionalSalaryForm = Time.now
    var_hash['tracking'].save!
  end
end
