class DirectoryController < ApplicationController
  def index
    #raise params.inspect
    @views = session[:sitrack_user].sitrack_views
    @regions = SitrackRegion.all
  end
  def no_access
    render(:layout => false)
  end
end
