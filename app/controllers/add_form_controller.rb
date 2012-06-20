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
    extract_values(SitrackAddForm.prepare(current_user, @form))
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
    extract_values(SitrackAddForm.prepare(current_user, @form))
    @form.email(current_user, @form_title)
    render(:template => 'shared/form_submitted', :layout => "no_sidebar")
  end
  
  private
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
  
  def preview
    render(:template => 'shared/preview', :layout => 'add_form_layout')
  end

  # Create the instance variables needed in the views  
  
  def formatted_date(value=nil)
    ApplicationController::formatted_date(value)
  end

end
