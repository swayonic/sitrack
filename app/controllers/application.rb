# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :dummy_cas, AuthenticationFilter, :authorize, :except => 'no_access'
  
  def dummy_cas
    session[:cas_receipt] = {}
    session[:cas_receipt][:user] = 'josh.starcher@uscm.org'
    session[:cas_receipt][:ssoGuid] = 'F167605D-94A4-7121-2A58-8D0F2CA6E026'
  end
  
  def authorize
    session[:sitrack_user] = SitrackUser.find_by_ssm_id(session[:user].id)
    unless session[:sitrack_user]
      redirect_to(:controller => 'directory', :action => 'no_access') 
    end
  end
end