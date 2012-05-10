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
    Rails.logger.info "1"
    unless params[:child] && params[:child][:person_id] 
      raise "Bad form post: "+params.inspect
      Rails.logger.info "2"
    end
    if params[:id]
      Rails.logger.info "3"
      #update
      @child = SitrackChild.find(params[:id])
      @child.update_attributes(params[:child])
    else
      Rails.logger.info "4"
      #insert
      @child = SitrackChild.create(params["child"])
    end
    if @child.valid?
      Rails.logger.info "5"
      # clear page caches
      @child.person.hr_si_applications do |app|
	      expire_action(:action => :index, :id => app.id)
	    end
      close_window
    else 
      Rails.logger.info "6"
      render(:action => :child, :layout => false)
    end
    Rails.logger.info "7"
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
