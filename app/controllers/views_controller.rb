class ViewsController < ApplicationController
  def index
    @views = session[:sitrack_user].sitrack_views
  end
  
  def edit
    @view = SitrackView.find(params[:id], :include => {:sitrack_view_columns => :sitrack_column}, :order => :position)
    @all_columns = SitrackColumn.find(:all, :order => :name)
    @unused_columns = @all_columns - @view.sitrack_columns
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
    #figure out what the current biggest position is
    @view_column = SitrackViewColumn.create(:sitrack_view_id => params[:id], 
                             :sitrack_column_id => params[:column_id],
                             :position => SitrackViewColumn.maximum('position')+1)
  end
  
  def remove_column
    @view_column = SitrackViewColumn.find(params[:view_column_id], 
                              :include => [:sitrack_view, :sitrack_column])
    @column = @view_column.sitrack_column
    @view = @view_column.sitrack_view
    @view_column.destroy
  end
end
