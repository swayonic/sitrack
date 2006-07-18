class JoinStaffFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      @form = SitrackJoinStaffForm.new(:hr_si_application_id => app_id, :approver_id => session[:user].person.id)
    end
    # display form
    setup
    unless request.get?
      # save and preview
      @person.update_attributes(params[:person])
      @mpd.update_attributes(params[:mpd])
      preview if @form.update_attributes(params[:form])
    end
  end
  
    
  def submit
    @form = SitrackForm.find(params[:id])
    setup
    var_hash = {'person' => @person,
                'approver' => @approver,
                'tracking' => @tracking}
    form_html = render_to_string(:template => 'acos_form/form', :layout => 'add_form_layout')
    @form.email(var_hash, form_html)
    @form_type = 'Join Staff'
    render(:template => 'shared/form_submitted', :layout => 'application')
  end
  
  private
  
  def preview
    render(:action => 'preview', :layout => 'add_form_layout')
  end
  
  # Create the instance variables needed in the views  
  def setup
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
    @approver = @form.approver
  end
end
