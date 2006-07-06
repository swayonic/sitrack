class SalaryFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      @form = @application.sitrack_salary_forms.first
      if !@form
        if @application.tracking.is_stint?
          SitrackStintSalaryForm.create(:hr_si_application_id => app_id, :approver_id => session[:user].person.id)
        else
          SitrackInternSalaryForm.create(:hr_si_application_id => app_id, :approver_id => session[:user].person.id)
        end
      end
    end
    # display form
    if request.get?
      setup
    else
      # save and preview
      
      
      preview if @form.valid?
    end
  end
  
    
  def submit
    @form = SitrackAddForm.find(params[:id])
    setup
    var_hash = {'person' => @person,
                'approver' => @approver}
    form_html = render_to_string(:template => 'add_form/form', :layout => 'form')
    @form.email(var_hash, form_html)
  end
  
  private
  
  def preview
    setup
    render(:action => 'preview', :layout => 'form')
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
  	@person.birthDate = Time.parse(@person.birthDate) if @person.birthDate
    @tracking = @application.sitrack_tracking
    @approver = @form.approver
  end

end
