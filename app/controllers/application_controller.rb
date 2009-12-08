require 'numeric'
require 'sitrack_user'
# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  filter_parameter_logging *FILTER_KEYS
  @@public_pages = ['up_monitor','no_access','logout','expire']
  skip_before_filter CAS::Filter, :only => @@public_pages
  before_filter AuthenticationFilter, :authorize, :except => @@public_pages
#  after_filter :connection_bar
  include ExceptionNotifiable	#Automatically generates emails of errors
  
  # Define the app name. This is used in authentication_filter
  @@application_name = "sitrack"
  cattr_accessor :application_name
  
  def logout
    reset_session
    redirect_to('https://signin.mygcx.org/cas/logout?service='+url_for(:controller => 'directory', :only_path => false ))
  end
  
  # this action just exists to test our error handling.
  def boom
    raise "boom"
  end
  
  def up_monitor
    raise "DB looks down" if SitrackTracking.find(:first).nil?
    render :text => "<html><body>looks good (we're up)</body></html>"
  end
  
  def self.formatted_date(value=nil)
    if value
      time = value.class == Time ? value : Time.parse(value) 
    else 
      time = Time.now
    end
    time.strftime('%m/%d/%Y')
  rescue ArgumentError
    return ""
  end
  
  def get_project(id)
    return '' if  0 == id || id.nil? || '' == id.to_s.strip # an id of 0 is useless. you're useless too
    @project_names ||= {}
    @project_names[id] ||= Rails.cache.fetch(['projects',id], :expires_in => 1.day) {ActiveRecord::Base.connection.select_value("SELECT name FROM #{HrSiProject.table_name} where SIProjectID = #{id}").to_s.strip}
  end
  
  def sitrack_user=(sitrack_user)
    session[:sitrack_user_id] = sitrack_user.id
    sitrack_user
  end
  
  def current_user
    if !@current_user && session[:user_id]
      @current_user = User.find(session[:user_id])
    end
    @current_user
  end
  
  def current_user=(user)
    session[:user_id] = user.id
    @current_user = user
  end
  
  private
  def sitrack_user
    unless @sitrack_user 
      @sitrack_user ||= authorize
      session[:sitrack_user_id] = @sitrack_user.id
    end
    @sitrack_user
  end
  # reset the user object in the session
  def reset_user
    sitrack_user = SitrackUser.find_by_ssm_id(current_user.id, :include => :sitrack_views)
  end
  
  def authorize
    if session[:sitrack_user_id].nil?
      @sitrack_user = SitrackUser.find_by_ssm_id(current_user.id)
      if @sitrack_user.nil?
        redirect_to(:controller => 'directory', :action => 'no_access'); return; 
      end
      session[:sitrack_user_id] = @sitrack_user.id
    else
      @sitrack_user = SitrackUser.find(session[:sitrack_user_id])
    end
    session[:session_id] = (@sitrack_user.sitrack_session || SitrackSession.create(:sitrack_user_id => session[:sitrack_user_id])).id
    return @sitrack_user
  end
  
  def sitrack_session
    @sitrack_session ||= SitrackSession.find(session[:session_id])
  end
  helper_method :sitrack_session
  
  def all_tables
    table_person = Person.table_name
    table_mpd = 'sitrack_Mpd'
    table_address = 'ministry_NewAddress'
    table_tracking = SitrackTracking.table_name
    table_users = 'sitrack_Users'
    table_staff = 'ministry_Staff'
    table_app = HrSiApplication.table_name
    table_views = 'sitrack_Views'
    table_columns = 'sitrack_Columns'
    table_vc = 'sitrack_View_Columns'
    table_queries = 'sitrack_Queries'
    table_criteria = 'sitrack_SavedCriteria'
    table_session = 'sitrack_Session'
    table_regions = 'ministry_RegionalTeam'
    table_children = 'sitrack_Children'
    table_files = 'sitrack_mpdFiles'
    table_apply = 'si_applies'
    return "#{table_person} p "+
  				 "LEFT JOIN #{table_staff} s on p.accountNo = s.accountNo "+
  				 "JOIN #{table_app} l on p.personID = l.fk_SIPersonID "+
  				 "LEFT JOIN #{table_mpd} m on l.applicationID = m.fk_applicationID "+
  				 "LEFT JOIN #{table_tracking} t on l.applicationID = t.fk_applicationID "+
  				 "LEFT JOIN #{table_apply} sa on l.apply_id = sa.id "
  end
  
  # since i'm doing a lot of raw SQL, i need to do my own escaping.
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
  
  def get_teams
    @teams ||= Rails.cache.fetch('teams', :expires_in => 1.day) do 
      teams = MinistryLocalLevel.find(:all, :conditions => "isActive = 'T'", :order => 'name')
      team_hash = {"" => ""}
      teams.each do |team|
        team_hash[team.teamID.to_s] = team.name
      end
      team_hash
    end
    return @teams
  end
  
  def get_teams_ordered
    @ordered_teams ||= Rails.cache.fetch('ordered_teams', :expires_in => 1.day) do 
      teams = MinistryLocalLevel.find(:all, :conditions => "isActive = 'T'", :order => 'name')
      team_array = [["", ""]]
      teams.each do |team|
        team_array << [team.teamID.to_s, team.name]
      end
      team_array
    end
    return @ordered_teams
  end
  helper_method :get_teams_ordered

  def get_options
    @options ||= Rails.cache.fetch('options', :expires_in => 1.day) do 
      options = Hash.new
      SitrackColumn.find(:all, :include => :sitrack_enum_values, :order => 'sitrack_enum_values.position').each do |column|
        options[column.name] = column.sitrack_enum_values.collect {|option| [option.value, option.name]} if column.column_type == 'enum'
      end
      options
    end
    return @options
  end
  
  def get_option_hash
    @option_hash ||= Rails.cache.fetch('option_hash', :expires_in => 1.day) do 
      options = get_options
      option_hash = {}
      options.each do |column_name, column_array|
        option_hash[column_name] = {}
        column_array.each { |options| option_hash[column_name][options[0]] = options[1] }
      end
      option_hash
    end
    return @option_hash
  end
  helper_method :get_option_hash
end