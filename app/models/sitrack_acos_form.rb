class SitrackACOSForm < SitrackForm
  def validate
    errors.add_on_empty('Effective Date of Change') if date_of_change.nil? || date_of_change.to_s.empty?
    super
  end
  
  def email(var_hash, form_html)
    to = 'Josh Starcher <josh.starcher@uscm.org>'
    email = FormMailer.create_form_email(to, var_hash, form_html, 'ACOS Form')
    FormMailer.deliver(email)
  end
end