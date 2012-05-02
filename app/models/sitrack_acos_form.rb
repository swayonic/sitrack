class SitrackAcosForm < SitrackForm
  
  attr_accessible :hr_si_application_id, :date_of_change, :freeze_start, :freeze_end,
    :change_assignment_from_location, :change_assignment_to_location, :restint_location,
    :hours_per_week, :other_explanation, :additional_notes
  
  def validate
    errors.add_on_empty('Effective Date of Change') if date_of_change.nil? || date_of_change.to_s.empty?
    super
  end
  
  def to
    if 'restint' == action
      'Celeste Allison <celeste.allison@ccci.org>'
    else
      'Personel Records <personnel.records@ccci.org>'
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