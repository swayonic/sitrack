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
  
  
  def email(current_user)
    extract_values(SitrackAcosForm.prepare(current_user, self))
    email = FormMailer.acos_form(current_user, @form, to, @form_type).deliver!
    
    # Stamp "form submitted" column
    @tracking.acosForm = Time.now
    @tracking.save!
  end
  
  def self.prepare(current_user, form)
    
    @form = form
    @form_title = 'ACOS'
    @options_hash = get_option_hash
    @application = @form.hr_si_application
    @person = @application.person
    @spouse = @person.spouse || Person.new
    @current_address = (@person.current_address || Address.new)
    @tracking = (@application.sitrack_tracking || SitrackTracking.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @approver = @form.approver = current_user.person
    
    var_hash = Hash.new
    var_hash['form_title'] = @form_title
    var_hash['form'] = @form
    var_hash['application'] = @application
    var_hash['person'] = @person
    var_hash['current_address'] = @current_address
    var_hash['spouse'] = @spouse
    var_hash['options_hash'] = @options_hash
    var_hash['region'] = @region
    var_hash['tracking'] = @tracking
    var_hash['approver'] = @approver
    
    return var_hash
  end
  
  def self.setup_action(form)
    var_hash = Hash.new
    statuses = ['termination','toIntern','toStint','withdrawal','changeLocation','restint','reintern','changeHours','other']
    statuses.each do |status|
      check = form.action == status ? '[X]' : '[&nbsp;&nbsp;]'
      var_hash["#{status}"] = "#{check}"
    end
    reopen = ['staff', 'intern', 'stint', 'freeze']
    reopen.each do |as|
      check = form.reopen_as == as ? '[X]' : '[&nbsp;&nbsp;]'
      var_hash["#{as}"] = "#{check}"
    end
    ['est','conf'].each do |certainty|
      check = form.departure_date_certainty == certainty ? '[X]' : '[&nbsp;&nbsp;]'
      var_hash["#{certainty}"] = "#{check}"
    end
    return var_hash
  end
  
  def self.get_option_hash
    @option_hash ||= Rails.cache.fetch('option_hash', :expires_in => 1.day) do 
      options = get_options
      option_hash = {}
      options.each do |column_name, column_array|
        option_hash[column_name] = {}
        column_array.each { |options| option_hash[column_name][options[0]] = options[1] }
      end
      option_hash
    end
    return @option_hash
  end
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
  
  
end