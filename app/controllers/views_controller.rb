class ViewsController < ApplicationController
  def index
    @views = sitrack_user.sitrack_views
  end
  
  def edit
    @view = SitrackView.find(params[:id], :include => [:sitrack_view_columns => :sitrack_column])
    @all_columns = SitrackColumn.find(:all, :order => :name)
    @unused_columns = @all_columns - @view.sitrack_columns
  end
  
  def update
    @view = SitrackView.find(params[:id])
    if @view.update_attributes(params[:sitrack_view])
      flash[:notice] = "Directory View successfully renamed"
      redirect_to :action=>:edit, :id=>@view
    else
      flash[:notice] = "Failed to rename Directory View"
      redirect_to :action=>:edit, :id=>@view
    end
  end
  
  def new
    if request.get?
      @view = SitrackView.new
    else 
      @view = SitrackView.new(:name => params[:view][:name])
      @view.sitrack_user = sitrack_user
      if @view.save
        reset_user # defined in application.rb
        redirect_to(:action => :edit, :id => @view.id)
      end
    end
  end
  
  def delete
    @view = sitrack_user.sitrack_views.find(params[:id])
    @view.destroy
    reset_user # defined in application.rb
    delete_cache(@view.id)
    redirect_to(:action => :index)
  end
  
  def reorder
    @view = SitrackView.find(params[:id], :include => :sitrack_view_columns)
    @view.sitrack_view_columns.each do |view_column|
      view_column.position = params['column_list'].index(view_column.id.to_s) + 1
      view_column.save
    end
    delete_cache(@view.id)
    render :nothing => true
  end
  
  def reorder_used
    @view = SitrackView.find(params[:id], :include => :sitrack_view_columns)
    @view.sitrack_view_columns.each do |view_column|
      view_column.position = params['used'].index(view_column.id.to_s) + 1
      view_column.save
    end
    delete_cache(@view.id)
    render :nothing => true
  end
  
  def save_name
    #raise params.inspect
    @view = SitrackView.find(params[:id])
    name = request.raw_post || request.query_string
    @view.name = name.gsub("%20", " ")
    @view.save!
    render :nothing => true
  end
  
  def add_column
    #raise params.inspect
    # make sure the column isn't already on this view (catch a double-click)
    @column = params[:column_id]
    @view_column = SitrackViewColumn.find(:first, 
                                          :conditions => ['sitrack_view_id = ? and sitrack_column_id = ?', params[:id], params[:column_id]])
    unless @view_column    
      @view_column = SitrackViewColumn.create(:sitrack_view_id => params[:id], 
                             :sitrack_column_id => params[:column_id],
                             :position => SitrackViewColumn.maximum('position')+1)
    end
    @view = @view_column.sitrack_view
    delete_cache(@view.id)
    
    @view = SitrackView.find(params[:id], :include => [:sitrack_view_columns => :sitrack_column])
    @all_columns = SitrackColumn.find(:all, :order => :name)
    @unused_columns = @all_columns - @view.sitrack_columns
    
    renderJS
  end
  
  def remove_column
    @view_column = SitrackViewColumn.find(params[:view_column_id], 
                              :include => [:sitrack_view, :sitrack_column])
    @column = @view_column.sitrack_column
    @view = @view_column.sitrack_view
    @view_column.destroy
    delete_cache(@view.id)
    
    
    @view = SitrackView.find(@view.id, :include => [:sitrack_view_columns => :sitrack_column])
    @all_columns = SitrackColumn.find(:all, :order => :name)
    @unused_columns = @all_columns - @view.sitrack_columns
    
    renderJS
    
  end
  
  def search
    @people = ''
    @name = request.raw_post || request.query_string
    if @name and !@name.empty? 
    	names = @name.strip.split('%20')
    	if (names.size > 1)
	    	first = names[0].gsub("=","")
    		last = names[1].empty? ? first : names[1].gsub("=","")
	    	@conditions = [ "ministry_person.lastName LIKE ? AND ministry_person.firstName LIKE ? ", last + "%", first + "%" ]
	   	else 
	   	  name = names.join.gsub("=","")
	   		@conditions = [ "(ministry_person.lastName LIKE ? OR ministry_person.firstName LIKE ?) ", name+'%',name+'%' ]
	   	end
	  	@people = SitrackUser.find(:all, :order => "lastName, firstName", 
	  	                                 :conditions => @conditions, 
	  	                                 :include => {:user => :person})
	  end
	  render(:layout => false)
  end
  
  def friend
    unless params[:id]
      redirect_to(:action => :borrow); return;
    end
    @user = SitrackUser.find(params[:id])
    @person = @user.user.person
    @views = @user.sitrack_views
  end
  
  def import
    unless params[:id]
      redirect_to(:action => :borrow); return;
    end
    @view = SitrackView.find(params[:id])
    @new_view = @view.clone
    @view.sitrack_view_columns.each do |vc|
      @new_view.sitrack_view_columns << vc.clone
    end
    sitrack_user.sitrack_views << @new_view
    redirect_to(:action => :index)
  end
  
  protected
  def delete_cache(view_id)
    template_with_path = "#{Rails.root}/app/views/directory/_results#{view_id}.rhtml"
    File.delete(template_with_path) if File.exist?(template_with_path)
  end
end
