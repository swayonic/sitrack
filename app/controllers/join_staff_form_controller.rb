class JoinStaffFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      @form = SitrackJoinStaffForm.new(:hr_si_application_id => app_id)
    end
    # display form
    setup
    unless request.get?
      if !params[:form][:hrd].present?
        flash[:notice] = "Name of approving HRD is required!"
        redirect_to :action => 'fill', :id => app_id
      else
        # save and preview
        expire_action(:controller => 'profile', :action => 'index', :id => app_id) # kill the profile cache

        @person.update_attributes(params[:person])
        @mpd.update_attributes(params[:mpd])
        @form.update_attributes(params[:form])
        preview if @person.valid? && @mpd.valid? && @form.save 
      end
    end
  end
  
    
  def submit
    @form = SitrackForm.find(params[:id])
    setup
    var_hash = {'person' => @person,
                'approver' => @approver,
                'tracking' => @tracking}
    @form.email(current_user, @form, var_hash)
    @form_type = 'Join Staff'
    render(:template => 'shared/form_submitted', :layout => 'application')
  end
  
  private
  
  def preview
    render(:template => 'shared/preview', :layout => 'add_form_layout')
  end
  
  # Create the instance variables needed in the views  
  def setup
    @title = 'Join Staff Form'
    @options_hash = get_option_hash
    @application = @form.hr_si_application
    @person = @application.person
    @current_address = @person.current_address || Address.new
    @tracking = @application.sitrack_tracking || SitrackTracking.new
    @spouse = @person.spouse || Person.new
    @form.spouse_name = @spouse.first_name
    @mpd = @application.sitrack_mpd || (@application.sitrack_mpd = SitrackMpd.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @approver = @form.approver = current_user.person
  end
end
