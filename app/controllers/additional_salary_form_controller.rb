class AdditionalSalaryFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackForm.find(params[:form_id])
    else
      app_id = params[:id]
      @application = HrSiApplication.find(app_id)
      @form = SitrackAdditionalSalaryForm.new(:hr_si_application_id => app_id, :approver_id => session[:user].person.id)
    end
    # display form
    setup
    unless request.get?
      # save and preview
      expire_action(:controller => :profile, :action => :index, :id => app_id) # kill the profile cache

      @person.update_attributes(params[:person])
      @application.update_attributes(params[:application])
      @tracking.update_attributes(params[:tracking])
      
      preview if @form.update_attributes(params[:form])
    end
    # make birthDate a Time
  	@person.birthDate = Time.parse(@person.birthDate) if @person.birthDate
  end
  
    
  def submit
    @form = SitrackForm.find(params[:id])
    setup
    add_tax
    var_hash = {'person' => @person,
                'approver' => @approver,
                'tracking' => @tracking}
    form_html = render_to_string(:template => 'additional_salary_form/form', :layout => 'additional_salary_form_layout')
    @form.email(var_hash, form_html)
    @form_type = 'Additioanl Salary'
    render(:template => 'shared/form_submitted', :layout => 'application')
  end
  
  private
  
  def preview
    add_tax
    render(:action => 'preview', :layout => 'additional_salary_form_layout')
  end
  
  # Create the instance variables needed in the views  
  def setup
    @application = @form.hr_si_application
    @person = @application.person
    @current_address = (@person.current_address || Address.new)
    @tracking = @application.sitrack_tracking
    @approver = @form.approver
  end
  
  def add_tax
    # add tax
    columns = %w{current_years_salary previous_years_salary additional_salary adoption
                counseling childrens_expenses college private_school graduate_studies auto_purchase
                settling_in_expenses reimbursable_expenses}
    @total = 0
    columns.each do |c|
      if @form[c]
        @form[c] = (@form[c] / (1-(@form.tax_rate.to_f/100))).round 
        eval("@#{c}_x = '[X]'")
        @total += @form[c].to_i
      else
        eval("@#{c}_x = '[&nbsp;&nbsp;]'")
      end
    end
  end
end
