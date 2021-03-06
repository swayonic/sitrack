class ApplicationController < ActionController::Base
  @@public_pages = ['up_monitor','no_access','logout','expire']
  include AuthenticatedSystem
  before_filter CASClient::Frameworks::Rails3::Filter, AuthenticationFilter, :authorize, :except => @@public_pages
  # before_filter CASClient::Frameworks::Rails3::Filter, AuthenticationFilter
  # skip_before_filter CAS::Filter, :only => @@public_pages
  # before_filter AuthenticationFilter, :authorize, :except => @@public_pages
  # after_filter :connection_bar
  
  # Define the app name. This is used in authentication_filter
  @@application_name = "sitrack"
  cattr_accessor :application_name
  
  def logout
    reset_session
    redirect_to('https://signin.ccci.org/cas/logout?service='+url_for(:controller => 'directory', :only_path => false ))
  end
  
  # this action just exists to test our error handling.
  def boom
    raise "boom"
  end
  
  def renderJS
  	respond_to do |format|
    	format.js if request.xhr?
			format.html
    end
  end
  
  def up_monitor
    raise "DB looks down" if SitrackTracking.find(:first).nil?
    render :text => "<html><body>looks good (we're up)</body></html>"
  end
  
  def self.formatted_date(value=nil)
    if value
      time = value.class == String ? Time.parse(value) : value
    else 
      time = Time.now
    end
    time.strftime('%m/%d/%Y')
  rescue ArgumentError
    return ""
  end
  
  def get_project(id)
    return '' if id.blank?
    @project_names ||= Rails.cache.fetch('projects', :expires_in => 1.day){{}}
    unless @project_names[id] 
      @project_names = @project_names.dup
      @project_names[id] = ActiveRecord::Base.connection.select_value("SELECT name FROM #{HrSiProject.table_name} where SIProjectID = #{id}").to_s.strip
      Rails.cache.write('projects',@project_names, :expires_in => 1.day)
    end
    @project_names[id]
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
    begin
      unless @sitrack_user 
        @sitrack_user ||= authorize
        session[:sitrack_user_id] = @sitrack_user.id
      end
      @sitrack_user
    rescue "Cannot Determine User"
      redirect_to "/"
    end
  end
  # reset the user object in the session
  def reset_user
    sitrack_user = SitrackUser.find_by_ssm_id(current_user.id, :include => :sitrack_views)
  end
  
  def authorize
    if session[:sitrack_user_id].nil?
      Rails.logger.info ">>>>>>>>>>>> #{current_user.to_json}"
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
    table_mpd = 'sitrack_mpd'
    table_address = 'ministry_newaddress'
    table_tracking = SitrackTracking.table_name
    table_users = 'sitrack_users'
    table_staff = 'ministry_staff'
    table_app = HrSiApplication.table_name
    table_views = 'sitrack_views'
    table_columns = 'sitrack_columns'
    table_vc = 'sitrack_view_columns'
    table_queries = 'sitrack_queries'
    table_criteria = 'sitrack_savedcriteria'
    table_session = 'sitrack_session'
    table_regions = 'ministry_regionalteam'
    table_children = 'sitrack_children'
    table_files = 'sitrack_mpdfiles'
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
      teams = Team.active.order('name')
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
      teams = Team.active.order('name')
      team_array = [["", ""]]
      teams.each do |team|
        team_array << [team.teamID.to_s, team.name]
      end
      team_array
    end
    return @ordered_teams
  end
  helper_method :get_teams_ordered

  def self.get_options
    unless @options
      options = Hash.new
      SitrackColumn.find(:all, :include => :sitrack_enum_values, :order => 'sitrack_enum_values.position').each do |column|
        options[column.name] = column.sitrack_enum_values.collect {|option| [option.value, option.name]} if column.column_type == 'enum'
      end
      @options = options
    end
    return @options
  end

  def get_options
    ApplicationController.get_options
  end

  def self.get_option_hash
    unless @option_hash
      options = get_options
      option_hash = {}
      options.each do |column_name, column_array|
        option_hash[column_name] = {}
        column_array.each { |options| option_hash[column_name][options[0]] = options[1] }
      end
      @option_hash = option_hash
    end
    @option_hash
  end
  

  def get_option_hash
    ApplicationController.get_option_hash
  end

  helper_method :get_option_hash
end
