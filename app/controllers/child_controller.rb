class ChildController < ApplicationController
  
  def add_child
    if params[:child].present?
      save_child
    else
      if params[:personID]
        @child = SitrackChild.new(:person_id => params[:personID])
        render(:action => :child, :layout => false)
      else
        close_window
      end
    end
  end
  
  def edit_child
    if params[:child].present?
      save_child
    else
      if params[:childID]
        @child = SitrackChild.find(params[:childID])
        @child.birthday = @child.birthday.strftime("%m/%d/%Y")
        render(:action => :child, :layout => false)    
      else
        close_window
      end
    end
  end
  
  def save_child
    unless params[:child].present? && params[:child][:person_id].present?
      raise "Bad form post: " + params.inspect
    end
    
    #Reformat Birthday
    bday = params[:child][:birthday]
    params[:child][:birthday] = Date.strptime(bday, '%m/%d/%Y').strftime('%Y-%m-%d') if bday.present?
    
    if params[:child][:id].present?
      #update
      @child = SitrackChild.find(params[:child][:id])
      @child.update_attributes(params[:child])
    else
      #insert
      @child = SitrackChild.create(params["child"])
    end
    if @child.valid?
      # clear page caches
      @child.person.hr_si_applications do |app|
	      expire_action(:action => :index, :id => app.id)
	    end
      close_window
    else 
      render(:action => :child, :layout => false)
    end
  end
  
  def delete_child
    @child_id = params[:id]
    SitrackChild.destroy(@child_id) if @child_id
    renderJS
  end
  
  private 
  
  def close_window
      render(:template => '/shared/close_window', :layout => false)
  end
end
