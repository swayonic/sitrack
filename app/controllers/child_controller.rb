class ChildController < ApplicationController
  
  def add_child
    if params[:personID]
      @child = SitrackChild.new(:person_id => params[:personID])
      render(:action => :child, :layout => false)
    else
      close_window
    end
  end
  
  def edit_child
    if params[:childID]
      @child = SitrackChild.find(params[:childID])
      render(:action => :child, :layout => false)    
    else
      close_window
    end
  end
  
  def save_child
    unless params[:child] && params[:child][:person_id] 
      raise "Bad form post: "+params.inspect
    end
    if params[:id]
      #update
      @child = SitrackChild.find(params[:id])
      @child.update_attributes(params[:child])
    else
      #insert
      @child = SitrackChild.create(params["child"])
    end
    if @child.valid?
      # clear page caches
      @child.person.si_applications do |app|
	      expire_action(:action => :index, :id => app.id)
	    end
      close_window
    else 
      render(:action => :child, :layout => false)
    end
  end
  
  def delete_child
    SitrackChild.destroy(params[:id]) if params[:id]
    render :nothing => true
  end
  
  private 
  
  def close_window
      render(:template => '/shared/close_window', :layout => false)
  end
end
