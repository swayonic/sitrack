require 'numeric'
# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter CAS::CASFilter, AuthenticationFilter, :authorize, :except => ['no_access','logout']
  #CAS::CASFilter
  # Define the app name. This is used in authentication_filter
  @@application_name = "sitrack"
  cattr_accessor :application_name
  
  def logout
    reset_session
    redirect_to('https://signin.mygcx.org/cas/logout?service='+url_for(:controller => 'directory', :only_path => false ))
  end
  
  private
  def dummy_cas
    session[:cas_receipt] = {}
    session[:cas_receipt][:user] = 'Scott.Santee@uscm.org'
    session[:cas_receipt][:ssoGuid] = '06A245FD-88DD-4624-4A00-65152E57122A'
  end
  
  def authorize
    if !session[:sitrack_user]
      session[:sitrack_user] = SitrackUser.find_by_ssm_id(session[:user].id)
      if session[:sitrack_user].nil?
        redirect_to(:controller => 'directory', :action => 'no_access'); return; 
      end
      sitrack_session = session[:sitrack_user].sitrack_session
      sitrack_session ||= SitrackSession.create(:sitrack_user_id => session[:sitrack_user].id)
      session[:session] = sitrack_session
    end
  end
  
  def all_tables
    table_person = Person.table_name
    table_mpd = 'sitrack_Mpd'
    table_address = 'ministry_NewAddress'
    table_tracking = SitrackTracking.table_name
    table_users = 'sitrack_Users'
    table_staff = 'ministry_Staff'
    table_app = SiApplication.table_name
    table_views = 'sitrack_Views'
    table_columns = 'sitrack_Columns'
    table_vc = 'sitrack_View_Columns'
    table_queries = 'sitrack_Queries'
    table_criteria = 'sitrack_SavedCriteria'
    table_session = 'sitrack_Session'
    table_regions = 'ministry_RegionalTeam'
    table_children = 'sitrack_Children'
    table_files = 'sitrack_mpdFiles'
    return "#{table_person} p "+
  				 "LEFT JOIN #{table_staff} s on p.accountNo = s.accountNo "+
  				 "JOIN #{table_app} l on p.personID = l.fk_SIPersonID "+
  				 "LEFT JOIN #{table_mpd} m on l.applicationID = m.fk_applicationID "+
  				 "LEFT JOIN #{table_tracking} t on l.applicationID = t.fk_applicationID "
  end
  
  def escape_string(str)
    str.gsub(/([\0\n\r\032\'\"\\])/) do
      case $1
      when "\0" then "\\0"
      when "\n" then "\\n"
      when "\r" then "\\r"
      when "\032" then "\\Z"
      else "\\"+$1
      end
    end
  end
  
  def get_options
    if !@options
      @options = Hash.new
      SitrackColumn.find_all.each do |column|
        @options[column.name] = column.sitrack_enum_values.collect {|option| [option.value, option.name]} if column.column_type == 'enum'
      end
    end
    return @options
  end
  def get_option_hash
    @options = get_options
    @option_hash = {}
    @options.each do |column_name, column_array|
      @option_hash[column_name] = {}
      column_array.each { |options| @option_hash[column_name][options[0]] = options[1]}
    end
    return @option_hash
  end
end