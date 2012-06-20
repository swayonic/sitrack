class AcosFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      @app_id = params[:id]
      @application = HrSiApplication.find(@app_id)
      @form = SitrackAcosForm.new(:hr_si_application_id => @app_id)
    end
    # display form
    extract_values(SitrackAcosForm.prepare(current_user, @form))
    @form.change_assignment_from_location ||= [get_teams[@tracking.asgTeam], @tracking.asgCity, @tracking.asgCountry].join(', ')
    @form.restint_location ||= @form.change_assignment_from_location
    unless request.get?
      # save and preview
      expire_action(:controller => 'profile', :action => 'index', :id => @app_id) # kill the profile cache

      @person.update_attributes(params[:person]) if params[:form][:action] == "toStint"
      @application.update_attributes(params[:application])
      @tracking.update_attributes(params[:trackingStint]) if params[:form][:action] == "toStint"
      @tracking.update_attributes(params[:tracking]) if params[:form][:action] == "restint"
      @form.update_attributes(params[:form])
      preview if @person.valid? && @application.valid? && @tracking.valid? && @form.save
    end
  end
  
    
  def submit
    @form = SitrackForm.find(params[:id])
    extract_values(SitrackAcosForm.prepare(current_user, @form))
    @form.email(current_user)
    render(:template => 'shared/form_submitted', :layout => "no_sidebar")
  end
  
  private
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
  
  def preview
    extract_values(SitrackAcosForm.setup_action(@form))
    render(:template => 'shared/preview', :layout => 'add_form_layout')
  end
  
  # Create the instance variables needed in the views  
end
