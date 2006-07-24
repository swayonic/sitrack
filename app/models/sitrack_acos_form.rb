class SitrackACOSForm < SitrackForm
  def validate
    errors.add_on_empty('Effective Date of Change') if date_of_change.nil? || date_of_change.to_s.empty?
    super
  end
  
  def to
    if hr_si_application.sitrack_tracking.is_stint?
      'Celeste Allison <celeste.allison@ccci.org>'
    else
      'Personel Records <personel.records@ccci.org>'
    end
  end  
  
  def email(var_hash, form_html)
    email = FormMailer.create_form_email(to, var_hash, form_html, 'ACOS Form')
    FormMailer.deliver(email)
    
    # Stamp "form submitted" column
    var_hash['tracking'].acosForm = Time.now
    var_hash['tracking'].save!
  end
end