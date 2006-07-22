class ViewsController < ApplicationController
  def index
    @views = session[:sitrack_user].sitrack_views
  end
  
  def edit
    @view = SitrackView.find(params[:id], :include => {:sitrack_view_columns => :sitrack_column}, :order => :position)
    @all_columns = SitrackColumn.find(:all, :order => :name)
    @unused_columns = @all_columns - @view.sitrack_columns
  end
  
  def new
    if request.get?
      @view = SitrackView.new
    else 
      @view = SitrackView.new(:name => params[:view][:name])
      @view.sitrack_user = session[:sitrack_user]
      if @view.save
        # reset the user object in the session
        session[:sitrack_user] = SitrackUser.find_by_ssm_id(session[:user].id, :include => :sitrack_views)
        redirect_to(:action => :edit, :id => @view.id)
      end
    end
  end
  
  def reorder
    @view = SitrackView.find(params[:id], :include => :sitrack_view_columns)
    @view.sitrack_view_columns.each do |view_column|
      view_column.position = params['column_list'].index(view_column.id.to_s) + 1
      view_column.save
    end
    render :nothing => true
  end
  
  def save_name
    #raise params.inspect
    @view = SitrackView.find(params[:id])
    @view.name = request.raw_post || request.query_string
    @view.save!
    render :nothing => true
  end
  
  def add_column
    #raise params.inspect
    # make sure the column isn't already on this view (catch a double-click)
    @view_column = SitrackViewColumn.find(:first, 
                                          :conditions => ['sitrack_view_id = ? and sitrack_column_id = ?', params[:id], params[:column_id]])
    unless @view_column    
      @view_column = SitrackViewColumn.create(:sitrack_view_id => params[:id], 
                             :sitrack_column_id => params[:column_id],
                             :position => SitrackViewColumn.maximum('position')+1)
    end
  end
  
  def remove_column
    @view_column = SitrackViewColumn.find(params[:view_column_id], 
                              :include => [:sitrack_view, :sitrack_column])
    @column = @view_column.sitrack_column
    @view = @view_column.sitrack_view
    @view_column.destroy
  end
end
