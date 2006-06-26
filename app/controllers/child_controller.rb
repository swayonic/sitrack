class ChildController < ApplicationController
  
  def add_child
    @child = SitrackChild.new(:person_id => params[:personID])
    render(:action => :child, :layout => false)
  end
  
  def edit_child
    @child = SitrackChild.find(params[:childID])
    render(:action => :child, :layout => false)    
  end
  
  def save_child
    if params[:id]
      #update
      @child = SitrackChild.find(params[:id])
      @child.update_attributes(params[:child])
    else
      #insert
      @child = SitrackChild.create(params["child"])
    end
    if @child.valid?
      render(:layout => false)
    else 
      render(:action => :child, :layout => false)
    end
  end
  
  def delete_child
    SitrackChild.destroy(params[:id]) if params[:id]
  end
end
