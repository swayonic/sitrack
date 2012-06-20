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
    extract_values(SitrackJoinStaffForm.prepare(current_user, @form))
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
    extract_values(SitrackJoinStaffForm.prepare(current_user, @form))
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
    render(:template => 'shared/preview', :layout => 'add_form_layout')
  end
end
