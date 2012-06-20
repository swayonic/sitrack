class SalaryFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      if @application.sitrack_tracking && @application.sitrack_tracking.is_stint?
        @form = SitrackStintSalaryForm.new(:hr_si_application_id => app_id)
      else
        @form = SitrackInternSalaryForm.new(:hr_si_application_id => app_id)
      end
    end
    @form.approver = current_user.person
    # display form
    extract_values(SitrackSalaryForm.prepare(current_user, @form))
    unless request.get?
      # save and preview
      if !params[:form][:annual_salary].present?
        flash[:notice] = "New Annual Base Salary is required and should be a number!"
        redirect_to :action => 'fill', :id => app_id
      else
        expire_action(:controller => 'profile', :action => 'index', :id => app_id) # kill the profile cache

        # Make birthDate a string
        params[:form][:annual_salary].gsub!(/[$,]/, '')
      
        @person.update_attributes(params[:person])
        @application.update_attributes(params[:application])
        @tracking.update_attributes(params[:tracking])
        @form.update_attributes(params[:form])
      
        preview if @person.valid? && @application.valid? && @tracking.valid? && @form.save
      end
    end
  end
    
  def submit
    @form = SitrackForm.find(params[:id])
    extract_values(SitrackSalaryForm.prepare(current_user, @form))
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
    render(:template => 'shared/preview', :layout => 'salary_form_layout')
  end

end
