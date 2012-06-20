class AdditionalSalaryFormController < ApplicationController
  
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      @form = SitrackAdditionalSalaryForm.new(:hr_si_application_id => app_id)
    end
    
    # display form
    extract_values(SitrackAdditionalSalaryForm.prepare(current_user, @form))
    
    unless request.get?
      # save and preview
      expire_action(:controller => 'profile', :action => 'index', :id => app_id) # kill the profile cache

      @person.update_attributes(params[:person])
      @application.update_attributes(params[:application])
      @tracking.update_attributes(params[:tracking])
      @form.update_attributes(params[:form])
      preview if @person.valid? && @application.valid? && @tracking.valid? && @form.save
    end
  end
  
    
  def submit
    @form = SitrackForm.find(params[:id])
    extract_values(SitrackAdditionalSalaryForm.prepare(current_user, @form))
    @form.email(current_user)
    render(:template => 'shared/form_submitted', :layout => 'application')
  end
  
  private
  
  def extract_values(hash)
    hash.each do |name, value|
      eval("@#{name} = value")
    end
  end
  
  def preview
    extract_values(SitrackAdditionalSalaryForm.add_tax(@form))
    render(:template => 'shared/preview', :layout => 'additional_salary_form_layout')
  end
  
end
