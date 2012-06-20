class FormMailer < ActionMailer::Base
  
  def form_email(to, var_hash, form_html, form_type)
    
    @subject = form_type + ' for '+var_hash['person'].full_name
    from_name = var_hash['approver'].full_name
    from_address = var_hash['approver'].email
    @from = "#{from_name} <#{from_address}>"
    @cc = @from
    @recipients = to
    @body = var_hash
    @body[:form_type] = form_type
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject, body: @body)
  end
  
  def join_staff_form(current_user, form, to, var_hash, form_type)
    @subject = form_type + ' for '+var_hash['person'].full_name
    from_name = var_hash['approver'].full_name
    from_address = var_hash['approver'].email
    @from = "#{from_name} <#{from_address}>"
    @cc = @from
    @recipients = to
    
    @person = var_hash["person"]
    @approver = var_hash["approver"]
    @tracking = var_hash["tracking"]
    
    @form = form
    @title = 'Join Staff Form'
    @options_hash = get_option_hash
    @application = @form.hr_si_application
    @person = @application.person
    @current_address = @person.current_address || Address.new
    @tracking = @application.sitrack_tracking
    @spouse = @person.spouse || Person.new
    @form.spouse_name = @spouse.first_name
    @mpd = @application.sitrack_mpd || (@application.sitrack_mpd = SitrackMpd.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @approver = @form.approver = current_user.person
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end
  
  def additional_salary_form(current_user, form, to, form_type)
    extract_values(SitrackAdditionalSalaryForm.prepare(current_user, form))
    extract_values(SitrackAdditionalSalaryForm.add_tax(form))
    
    @subject = "#{form_type} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @recipients = to
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end

  def salary_form(current_user, form, to, var_hash, form_type)
    @subject = form_type + ' for '+var_hash['person'].full_name
    from_name = var_hash['approver'].full_name
    from_address = var_hash['approver'].email
    @from = "#{from_name} <#{from_address}>"
    @cc = @from
    @recipients = to
    
    @person = var_hash["person"]
    @approver = var_hash["approver"]
    @tracking = var_hash["tracking"]
    
    @form = form
    @application = @form.hr_si_application
    @person = @application.person
    @current_address = @person.current_address || CurrentAddress.create(:person_id => @person.id)
    @tracking = @application.sitrack_tracking || SitrackTracking.new
    @tracking.asgCity  = @current_address.city if @tracking.asgCity.nil? || @tracking.asgCity.empty?
    @tracking.asgState  = @current_address.state if @tracking.asgState.nil? || @tracking.asgState.empty?
    @tracking.asgCountry  = @current_address.country if @tracking.asgCountry.nil? || @tracking.asgCountry.empty?
    @mpd = @application.sitrack_mpd || SitrackMpd.new
    @approver = @form.approver = current_user.person
    # If current date is >= 5th and <= 20th, put the 16th. Else put 1st
    day = Time.now.day
    month = Time.now.month
    year = Time.now.year
  	if (day >= 5 && day <= 20) 
  		date = Time.local(year, month, 16)
  	elsif (day > 20)
  	  month = month+1
      year += 1 if month == 13
      month = 1 if month == 13
  		date = Time.local(year, month, 1)
  	else
  		date = Time.local(year, month, 1)
  	end
    @form.date_of_change ||= date
    @form.annual_salary ||= @mpd.salary.to_i * 12 if @mpd.salary
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end
  
  def add_form(current_user, form, to, form_type)
    extract_values(SitrackAddForm.prepare(current_user, form))
    
    @subject = "#{form_type} Form for #{@person.full_name}"
    @from = "#{@approver.full_name} <#{@approver.email}>"
    @cc = @from
    @recipients = to
    
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end
  
  def acos_form(current_user, form, to, var_hash, form_type)
    @subject = form_type + ' for '+var_hash['person'].full_name
    from_name = var_hash['approver'].full_name
    from_address = var_hash['approver'].email
    @from = "#{from_name} <#{from_address}>"
    @cc = @from
    @recipients = to
    
    @person = var_hash["person"]
    @approver = var_hash["approver"]
    @tracking = var_hash["tracking"]
    
    @form = form
    @title = 'ACOS Form'
    @options_hash = get_option_hash
    @application = @form.hr_si_application
    @person = @application.person
    @spouse = @person.spouse || Person.new
    @current_address = (@person.current_address || Address.new)
    @tracking = (@application.sitrack_tracking || SitrackTracking.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @approver = @form.approver = current_user.person
    setup_acos_action
    mail(from: @from, to: @recipients, cc: @cc, subject: @subject)
  end
  
  private
  
  def setup_acos_action
    statuses = ['termination','toIntern','toStint','withdrawal','changeLocation','restint','reintern','changeHours','other']
    statuses.each do |status|
      check = @form.action == status ? '[X]' : '[&nbsp;&nbsp;]'
      eval("@#{status} = '#{check}'")
    end
    reopen = ['staff', 'intern', 'stint', 'freeze']
    reopen.each do |as|
      check = @form.reopen_as == as ? '[X]' : '[&nbsp;&nbsp;]'
      eval("@#{as} = '#{check}'")
    end
    ['est','conf'].each do |certainty|
      check = @form.departure_date_certainty == certainty ? '[X]' : '[&nbsp;&nbsp;]'
      eval("@#{certainty} = '#{check}'")
    end
  end
  
  def get_option_hash
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
  
  def get_teams
    @teams ||= Rails.cache.fetch('teams', :expires_in => 1.day) do 
      teams = Team.active.order('name')
      team_hash = {"" => ""}
      teams.each do |team|
        team_hash[team.teamID.to_s] = team.name
      end
      team_hash
    end
    return @teams
  end
  
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
end
