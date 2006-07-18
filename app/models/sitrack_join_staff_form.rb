class SitrackJoinStaffForm < SitrackForm
  def validate
    errors.add_on_empty('Effective Date of Change') if date_of_change.nil? || date_of_change.to_s.empty?
    errors.add_on_empty('Account Number') if hr_si_application.person.accountNo.nil? || hr_si_application.person.accountNo.empty?
    errors.add_on_empty('MPD Coach') if hr_si_application.sitrack_mpd.coachName.nil? || hr_si_application.sitrack_mpd.coachName.empty?
    errors.add_on_empty('Name of approving HRD') if hrd.nil? || hrd.empty?
    super
  end
  
  def email(var_hash, form_html)
    to = 'Josh Starcher <josh.starcher@uscm.org>'
    email = FormMailer.create_form_email(to, var_hash, form_html, 'Join Staff Form')
    FormMailer.deliver(email)
    
    # Stamp "form submitted" column
    var_hash['tracking'].joinStaffForm = Time.now
    var_hash['tracking'].save!
  end
end