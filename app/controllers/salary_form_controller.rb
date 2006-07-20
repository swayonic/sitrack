class SalaryFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      @form = @application.sitrack_salary_forms.first
      if !@form
        if @application.sitrack_tracking && @application.sitrack_tracking.is_stint?
          @form = SitrackStintSalaryForm.new(:hr_si_application_id => app_id, :approver_id => session[:user].person.id)
        else
          @form = SitrackInternSalaryForm.new(:hr_si_application_id => app_id, :approver_id => session[:user].person.id)
        end
      end
    end
    # display form
    setup
    unless request.get?
      # save and preview
      expire_action(:controller => 'profile', :action => 'index', :id => app_id) # kill the profile cache

      # Make birthDate a string
      params[:form][:annual_salary].gsub!(/[$,]/, '')
      @person.update_attributes(params[:person])
      @application.update_attributes(params[:application])
      
      @tracking.update_attributes(params[:tracking])
      
      preview if @form.update_attributes(params[:form])
    end
  end
    
  def submit
    @form = SitrackForm.find(params[:id])
    setup
    var_hash = {'person' => @person,
                'approver' => @approver,
                'tracking' => @tracking}
    form_html = render_to_string(:template => 'salary_form/form', :layout => 'salary_form_layout')
    @form.email(var_hash, form_html)
    @form_type = 'Salary'
    render(:template => 'shared/form_submitted')
  end
  
  private
  
  def preview
    render(:action => 'preview', :layout => 'salary_form_layout')
  end

  # Create the instance variables needed in the views  
  def setup
    @application = @form.hr_si_application
    @person = @application.person
    # If current date is >= 5th and <= 20th, put the 16th. Else put 1st
    day = Time.now.day
    month = Time.now.month
    year = Time.now.year
  	if (day >= 5 && day <= 20) 
  		date = Time.local(year, month, 16)
  	elsif (day > 20)
  		date = Time.local(year, month+1, 1)
  	else
  		date = Time.local(year, month, 1)
  	end
    @form.date_of_change ||= date
    @tracking = @application.sitrack_tracking || SitrackTracking.new
    @approver = @form.approver
  end

end
