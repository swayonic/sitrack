class AddFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackAddForm.find(params[:form_id])
    else
      app_id = params[:id]
      @form = SitrackAddForm.new(:hr_si_application_id => app_id)
      @form.approver = current_user.person
      @form.save
    end
    setup
		unless request.get?
      if !params[:tracking][:caringRegion].present?
        flash[:notice] = "Caring Region is required!"
        redirect_to :action => 'fill', :id => app_id
      else
        # save and preview
        expire_action(:controller => 'profile', :action => 'index', :id => app_id) # kill the profile cache

        @person.update_attributes(params[:person])
        @application.update_attributes(params[:application])
        @tracking.update_attributes(params[:tracking])
        @form.update_attributes(params[:form])
        preview if @person.valid? && @application.valid? && @tracking.valid? && @form.valid?
      end
    end
  end
  
  def submit
    @form = SitrackAddForm.find(params[:id])
    setup
    var_hash = {'person' => @person,
                'approver' => @approver,
                'tracking' => @tracking}
    form_html = render_to_string(:template => 'shared/form', :layout => 'add_form_layout')
    # @form.email(var_hash, form_html)
    @form_type = 'Add'
    render(:template => 'shared/form_submitted')
  end
  
  private
  
  def preview
    setup
    render(:template => 'shared/preview', :layout => 'add_form_layout')
  end

  # Create the instance variables needed in the views  
  def setup
    @title = 'STAFF ADD NOTICE - Class A Only'
    @application = @form.hr_si_application
    @person = @application.person
    @current_address = (@person.current_address || Address.new)
    @emergency_address = (@person.emergency_address1 || Address.new)
    @permanent_address = (@person.permanent_address || Address.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @tracking = @application.sitrack_tracking || SitrackTracking.new
    @spouse = (@person.spouse || Person.new)
    @stint = @tracking.is_stint?
    @location = @stint ? [@tracking.asgCity, @tracking.asgCountry].join(', ') : @tracking.asgTeam
    @approver = @form.approver = current_user.person
    @teams = get_teams
  end

end
