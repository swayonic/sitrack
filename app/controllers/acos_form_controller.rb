class AcosFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      @form = SitrackACOSForm.new(:hr_si_application_id => app_id, :approver_id => session[:user].person.id)
    end
    # display form
    setup
    @form.change_assignment_from_location ||= [@tracking.asgTeam, @tracking.asgCity, @tracking.asgCountry].join(', ')
    @form.restint_location ||= @form.change_assignment_from_location
    unless request.get?
      # save and preview
      expire_action(:controller => 'profile', :action => 'index', :id => app_id) # kill the profile cache

      @person.update_attributes(params[:person])
      @application.update_attributes(params[:application])
      @tracking.update_attributes(params[:tracking])
      
      preview if @form.update_attributes(params[:form])
    end
  end
  
    
  def submit
    @form = SitrackForm.find(params[:id])
    setup
    setup_action
    var_hash = {'person' => @person,
                'approver' => @approver,
                'tracking' => @tracking}
    form_html = render_to_string(:template => 'acos_form/form', :layout => 'add_form_layout')
    @form.email(var_hash, form_html)
    @form_type = 'ACOS'
    render(:template => 'shared/form_submitted', :layout => 'application')
  end
  
  private
  
  def preview
    setup_action
    render(:action => 'preview', :layout => 'add_form_layout')
  end
  
  # Create the instance variables needed in the views  
  def setup
    @title = 'ACOS Form'
    @options_hash = get_option_hash
    @application = @form.hr_si_application
    @person = @application.person
    @spouse = @person.spouse || Person.new
    @current_address = (@person.current_address || Address.new)
    @tracking = (@application.sitrack_tracking || SitrackTracking.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @approver = @form.approver
  end
  
  def setup_action
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
end
