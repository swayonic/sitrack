class AddFormController < ApplicationController
  def fill
    if params[:form_id]
      @form = SitrackAddForm.find(params[:form_id])
    else
      app_id = params[:id]
      @form = (SitrackAddForm.find(:first, :conditions => ['hr_si_application_id = ?', app_id]) || 
                SitrackAddForm.create(:hr_si_application_id => app_id,
                                      :approver_id => session[:user].person.id))
    end
    if @form.valid?
      preview
    else
      render
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
    @current_address = (@person.current_address || Address.new)
    @emergency_address = (@person.emergency_address1 || Address.new)
    @permanent_address = (@person.permanent_address || Address.new)
    @region = (Region.find_by_region(@person.region) || Region.new)
    @tracking = @application.sitrack_tracking
    @spouse = (@person.spouse || Person.new)
    @stint = @tracking.is_stint?
    @location = @stint ? [@tracking.asgCity, @tracking.asgCountry].join(', ') : @tracking.asgTeam
    @approver = @form.approver
  end

end
