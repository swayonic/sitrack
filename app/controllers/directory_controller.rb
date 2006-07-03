class DirectoryController < ApplicationController
  def index
    show_directory
  end       
  
  def show_directory
    @views = session[:sitrack_user].sitrack_views
    @regions = SitrackRegion.all
    # look for a view_id stored in the session
    view_id = session[:session].get_value('view_id') 
    
    # set up the view
    @view ||= view_id ? SitrackView.find(view_id, :include => [:sitrack_view_columns, :sitrack_columns], :order => 'sitrack_view_columns.position') :
          session[:sitrack_user].sitrack_views.find(:first, :include => [:sitrack_view_columns, :sitrack_columns])
    
    session[:session].save_value('view_id', @view.id) unless @view.id == view_id
    
    # if we have a query_id in the session, use the saved list
    if (query_id = session[:session].get_value('query_id'))
      @current_query = SitrackQuery.find_by_id(query_id)
      if (@current_query)
        @where_clause = ' applicationID IN('+@current_query.persons+') ' 
        @selected_options = nil
      end
    end
    
    # if we have a criteria_id in the session, use the saved query
    if (criteria_id = session[:session].get_value('criteria_id'))
      @current_criteria = SitrackSavedCriteria.find_by_id(criteria_id)
      if @current_criteria
        @qs = @current_criteria.criteria
        @selected_options = @current_criteria.options
      end
    end
    
    build_query
    

    #############################
    #### Get ready to render ####
    #############################
    @order_column = @order_by.split(' ')[0]
    @order_direction = @order_by.split(' ')[1]
    
    
    @saved_queries = SitrackQuery.find_all_by_owner(session[:sitrack_user].id, :order => :name)
    @saved_criteria = SitrackSavedCriteria.find_all_by_owner(session[:sitrack_user].id, :conditions => 'saved = 1', :order => :name)
    @sel_region_name ||= '%'
    
    get_projects
    
    # get the search options
    @options = get_options
    @options_hash = get_option_hash
    
    # text fields:
    @first_name = @selected_options ? (@selected_options.match(/<first_name>(.*)<\/first_name>/) ? $1 : '') : ''
    @last_name = @selected_options ? (@selected_options.match(/<last_name>(.*)<\/last_name>/) ? $1 : '') : ''
    @pref_name = @selected_options ? (@selected_options.match(/<pref_name>(.*)<\/pref_name>/) ? $1 : '') : ''
    render(:action => :show_directory)
  end
  
  def search
    @options = get_options if !@options
    query_string = {:status => '', :type => '', :position => '', :tenure => '', :misc => '',   
                    :region_of_origin => '', :caring_region => '', :app_year => '', :name => ''}
    @selected_options = ''
    
    ## Application Status
    SiApplicationStatus.all.each do |status|
      if params['status_'+status[0]]
        join = (query_string[:status] == '') ? ' AND (' : ' OR '
        query_string[:status] += join + SitrackTracking.table_name + ".status = '#{status[1]}'"
        @selected_options += "[status_#{status[0]}]"
      end
    end
    query_string[:status] += ')' unless query_string[:status] == ''
    
    
    ## Intern Type
    @options['Intern Type'].each do |type|
      if params['type_'+type[0]]
        join = (query_string[:type] == '') ? ' AND (' : ' OR '
        query_string[:type] += join + SitrackTracking.table_name + ".internType = '#{type[1]}'"
        @selected_options += "[type_#{type[0]}]"
      end
    end
    query_string[:type] += ')' unless query_string[:type] == ''
    
    ## Position
    @options['Position'].each do |position|
      if params['position_'+position[0]]
        join = (query_string[:position] == '') ? ' AND (' : ' OR '
        query_string[:position] += join + Person.table_name + ".isStaff = #{position[0]}"
        @selected_options += "[position_#{position[0]}]"
      end
    end
    query_string[:position] += ')' unless query_string[:position] == ''
    
    ## Tenure
    @options['Tenure'].each do |tenure|
      if params['tenure_'+tenure[0]]
        join = (query_string[:tenure] == '') ? ' AND (' : ' OR '
        query_string[:tenure] += join + SitrackTracking.table_name + ".tenure = '#{tenure[1]}'"
        @selected_options += "[tenure_#{tenure[0]}]"
      end
    end
    query_string[:tenure] += ')' unless query_string[:tenure] == ''
    
    ## Misc options
    if params['misc_team_leader']
      query_string[:misc] += " AND teamLeader = 1 ";
			@selected_options += '[misc_team_leader]';
    end
    if params['misc_monthly_birthday']
      query_string[:misc] += " AND MONTH(STR_TO_DATE(birthDate, '%m/%d/%Y')) = Month(NOW()) ";
			@selected_options += '[misc_monthly_birthday]';
    end
    
    ## Region of Origin
    @options['Region of Origin'].each do |region|
      if params['region_of_origin_'+region[0]]
        join = (query_string[:region_of_origin] == '') ? ' AND (' : ' OR '
        query_string[:region_of_origin] += join + Person.table_name + ".region = '#{region[1]}'"
        @selected_options += "[region_of_origin_#{region[0]}]"
      end
    end
    query_string[:region_of_origin] += ')' unless query_string[:region_of_origin] == ''
    
    ## Caring Region
    @options['Caring Region'].each do |region|
      if params['caring_region_'+region[0]]
        join = (query_string[:caring_region] == '') ? ' AND (' : ' OR '
        query_string[:caring_region] += join + SitrackTracking.table_name + ".caringRegion = '#{region[1]}'"
        @selected_options += "[caring_region_#{region[0]}]"
      end
    end
    query_string[:caring_region] += ')' unless query_string[:caring_region] == ''
    
    ## App Year
    @options['App Year'].each do |app_year|
      if params['app_year_'+app_year[0]]
        join = (query_string[:app_year] == '') ? ' AND (' : ' OR '
        query_string[:app_year] += join + HrSiApplication.table_name + ".siYear = '#{app_year[1]}'"
        @selected_options += "[app_year_#{app_year[0]}]"
      end
    end
    query_string[:app_year] += ')' unless query_string[:app_year] == ''

    # Check first, last and preferred names
		if (@first_name = params["first_name"]) && @first_name != ''
			query_string[:name] += " AND #{Person.table_name}.firstName LIKE '#{escape_string(@first_name)}%' "
			@selected_options += '<first_name>' + @first_name + '</first_name>';
		end
		if (@last_name = params["last_name"]) && @last_name != ''
			query_string[:name] += " AND #{Person.table_name}.lastName LIKE '#{escape_string(@last_name)}%' "
			@selected_options += '<last_name>' + @last_name + '</last_name>';
		end
		if (@pref_name = params["pref_name"]) && @pref_name != ''
			query_string[:name] += " AND #{Person.table_name}.preferredName LIKE '#{escape_string(@pref_name)}%' "
			@selected_options += '<pref_name>' + @pref_name + '</pref_name>';
		end
    
    @qs = query_string.values.join
    
    # save the query criteria
    @criteria = SitrackSavedCriteria.create(:owner => session[:sitrack_user].id, :criteria => @qs, :options => @selected_options)
    # put the criteria in the session
    session[:session].save_value('criteria_id',@criteria.id)
    # remove any query_id. You can't use a criteria and query at the same time.
    session[:session].remove_value('query_id')
    show_directory
  end
  
  def show_query
    query_id = params[:id]
    # if we don't have a query id, just show the directory
    if query_id
      session[:session].save_value('query_id', query_id)
      # clear any unsaved stored criteria
      session[:session].remove_value('criteria_id')
      SitrackSavedCriteria.delete_all("owner = #{session[:sitrack_user].id} AND saved = 0")
    end
    show_directory
  end
  
  def show_criteria
    criteria_id = params[:id]
    # if we don't have a criteria id, just show the directory
    if criteria_id
      session[:session].save_value('criteria_id', criteria_id)
      # remove any query_id. You can't use a criteria and query at the same time.
      session[:session].remove_value('query_id')
    end
    show_directory
  end
  
  def delete_query
    # make sure they own the query
    query = SitrackQuery.find_by_owner_and_id(session[:sitrack_user].id, params[:id])
    query.destroy if query
    index
  end
  
  def delete_criteria
    # make sure they own the query
    criteria = SitrackSavedCriteria.find_by_owner_and_id(session[:sitrack_user].id, params[:id])
    criteria.destroy if criteria
    index
  end
  
  def save_query
    if request.post? && params[:name] && params[:id_list]
      query = SitrackQuery.create(:name => params[:name], :owner => session[:sitrack_user].id, :persons => params[:id_list])
      session[:session].save_value('query_id', query.id)
    end
    show_directory
  end
  
  def append_query
    if request.post? && params[:id] && params[:id_list]
      # make sure they own this query
      query = SitrackQuery.find_by_owner_and_id(session[:sitrack_user].id, params[:id])
      if query
        curr_list = query.persons.split(',')
        add_list = params[:id_list].split(',')
        query.persons = (curr_list + add_list).uniq.join(',')
        query.save! 
        session[:session].save_value('query_id', query.id)
      end
    end
    show_directory   
  end
  
  def save_criteria
    if request.post? && params[:name] && (id = session[:session].get_value('criteria_id'))
      criteria = SitrackSavedCriteria.find(id)
      criteria.name = params[:name]
      criteria.saved = 1
      criteria.save!
    end
    show_directory
  end
  
  def change_region
    session[:session].save_value('region', params[:region]) if params[:region]
    show_directory
  end
  
  def change_view
    view_id = params[:view_id].to_i
  	# save view in session object
  	session[:session].save_value('view_id', view_id) if view_id != 0
  	show_directory
  end
  
  def no_access
    render(:layout => false)
  end
  
  def calendar
    if request.post?
      @iMonth = params[:selMonth]
      @iYear = params[:selYear]
    elsif params[:SelectDate]
      begin
        @iMonth = Time.parse(params[:SelectDate]).month - 1
        @iYear = Time.parse(params[:SelectDate]).year
      rescue
        @iMonth = Time.now.month - 1
        @iYear = Time.now.year
      end
    else
      @iMonth = Time.now.month - 1
      @iYear = Time.now.year
    end
    render(:layout => false)
  end
  
  def modify_value
    app_id = params[:id]
    value = escape_string(params[:value].to_s.strip)
    type = params[:type]
    value = (value != '' ? Time.parse(value).strftime('%Y-%m-%d') : '') if type == 'date'
    # if this is an address field from the profile table, handle it differently
    if type == 'address'
      @sql = "UPDATE #{Address.table_name} "+
             "SET #{params[:fieldname]} = '#{value}', "+
             "    dateChanged = NOW(), "+
             "    changedBy = 'SITRACK' "+
             "WHERE addressID = #{params[:colID]}"
       @result = ActiveRecord::Base.connection.update(@sql)
    else
      column = (SitrackColumn.find_by_id(params[:colID]) || SitrackColumn.new(:select_clause => params[:selectClause]))
      # get the table name
      table = column.table_clause.split(',')[0].constantize.table_name
      # If this is an mpd field, make sure we're entering a numeric value.
    	# there's a list of mpd fields we don't want to force numeric:
    	safe_columns = ['coachName', 'updated_at', 'coachEmail', 'coachPhone', 'coachCell']
    	if (table == SitrackMpd.table_name)
    	  # make sure they have an mpd row
    	  mpd = SitrackMpd.find(:first, :conditions => ['application_id = ?', app_id]) || SitrackMpd.create(:application_id => app_id)
    	  # strip commas and dollar signs
  		  value = value.scan(/\d/).join unless safe_columns.include?(column.select_clause)
        value = 'NULL' if value == ''
  		end
    	# If we have an update clause, use it
    	if (column.update_clause && column.update_clause != '')
    	  #replace table names
    	  column.update_clause.gsub!('$table_mpd',SitrackMpd.table_name).gsub!('$table_address',Address.table_name)
    	  # replace question marks
    	  column.update_clause.sub!(/\?/, value.to_s) # the first question mark is the value
        # If this is an address, use the person id instead of the application id
    		if Address.table_name == table
    			# Get the person id
    			application = HrSiApplication.find(app_id)
    			id = application.fk_personID
    		else 
    		  id = app_id
    		end
        column.update_clause.gsub!(/\?/, id) # the rest are the id
    	  queries = column.update_clause.split(';')
    	  queries.each {|@sql| @result = ActiveRecord::Base.connection.update(@sql)}
    	else
        # Use the select string to figure out which column to update
        # set some default values
        id = app_id  
        where = 'application_id'
        set = ''
        
        # First, perform some extra logic depeding on which table we're updating
        case table
        when Person.table_name
          id = HrSiApplication.find(app_id).fk_personID
          where = Person.primary_key
          set = ", changedBy = 'SITRACK', dateChanged = NOW() "
        when SitrackTracking.table_name
          # make sure they have a tracking row
          SitrackTracking.find(:first, :conditions => ['application_id = ?', app_id]) || SitrackTracking.create(:application_id => app_id)
        when HrSiApplication.table_name
          where = HrSiApplication.primary_key
        end
        @sql = "UPDATE #{table} SET #{column.select_clause} = #{value ? "'#{value}'" : NULL} #{set} WHERE #{where} = #{id}"
        @result = ActiveRecord::Base.connection.update(@sql)
    	end
    end
    # clear page cache
    expire_action(:action => :index, :id => app_id)
    @column = column
    render :layout => false
  end
  
  def fix_criteria
    @options_hash = get_option_hash
    @criteria = SitrackSavedCriteria.find_all
    @criteria.each do |c|
      ['Status', 'Intern Type', 'Position', 'Tenure', 'App Year'].each do |field|
        raise field.inspect unless @options_hash[field]
        @options_hash[field].each do |value|
          c.options.gsub!('['+value[1]+']', '['+u(field.downcase)+'_'+value[0]+']')
        end
      end
      c.options.gsub!('[o_', '[region_of_origin_')
      c.options.gsub!('[c_', '[caring_region_')
      c.options.gsub!('[y','[app_year_')
      c.options.gsub!('[team_leader]','[misc_team_leader]')
      c.options.gsub!('[monthly_birthday]','[misc_monthly_birthday]')
      c.save!
    end
  end
  
  def excel_download
    #get the view
    @view = SitrackView.find(session[:session].get_value('view_id'), 
                            :include => [:sitrack_view_columns, :sitrack_columns], 
                            :order => 'sitrack_view_columns.position')
    # figure out what to call the downlaod
    if (id = session[:session].get_value('query_id'))
      query = SitrackQuery.find(id)
      name = query.name
      @where_clause = " #{HrSiApplication.table_name}.applicationID in( #{query.persons} ) "
    elsif (id = session[:session].get_value('criteria_id'))
      criteria = SitrackSavedCriteria.find(id)
      name = criteria.name
      @qs = criteria.criteria
    end
    name = @view.name if !name || name.empty?
    where ||= ''
    
    build_query
    
    @options_hash = get_option_hash
    
    get_projects
    
    headers['Content-Type'] = "application/vnd.ms-excel" 
    headers['Content-Disposition'] = "attachment; filename=\"#{name}.xls\""
    headers['Cache-Control'] = ''

    render_without_layout
  end
  
  #####################
  ##### PRIVATE #######
  #####################
  private
  #########################      
  #### Query           ####
  #########################
  def build_query
    @sel_region_name = session[:session].get_value('region') || session[:user].person.region
    @sel_region_name = '%' if @sel_region_name == 'all'
    all_where = "( #{Person.table_name}.region LIKE '#{@sel_region_name}' OR #{SitrackTracking.table_name}.caringRegion LIKE '#{@sel_region_name}' ) "+
			     "AND (#{Person.table_name}.firstName <> '' OR #{Person.table_name}.lastName <>'' )"
    select_clause = @view.display_columns
    from_clause = SitrackView.join_tables
    @where_clause = all_where unless @where_clause
    @sql = 'SELECT '+select_clause+' FROM '+from_clause+' WHERE '+@where_clause
    
    # If we have a search or saved criteria, add the query string.
    @sql += @qs if @qs
    @order_by = get_order_by(@view)
    @people = ActiveRecord::Base.connection.select_all(@sql+' ORDER BY '+@order_by)
  end
  
  # get all the project, and create an array of id=> name pairs
  def get_projects
    if @view.sitrack_columns.detect {|c| 'project' == c.column_type}
      projects_hash = ActiveRecord::Base.connection.select_all("SELECT SIProjectID, name FROM #{HrSiProject.table_name}")
      @projects = Array.new
      projects_hash.each {|p| @projects[p['SIProjectID'].to_i] = p['name']}
    end
  end
  
  def u(str)
    str.strip.gsub(/ /, '_')
  end
  def get_order_by(view)
    # if there is a query id in the params, set the session value
    if (params[:order_by])
      order_by = params[:order_by]
      session[:session].save_value('order_by', order_by)
    end
    # if we have a order_by in the session, use it
    order_by = session[:session].get_value('order_by')
    # Set up a default orderby
    # if "Full Name" is a column, sort by that. Otherwise, try lastname
    columns = view.safe_column_names
    if columns.include?('Full_Name')
    	default = "Full_Name asc";
    elsif columns.include?('Last_Name')
    	default = "Last_Name asc"
    else
    	# make sure there is a default
    	default = Person.table_name+'.personID asc'
    end
    default += ", First_Name asc"if columns.include?('First_Name')
    return (order_by && columns.include?(order_by.split(' ')[0])) ? order_by : default
  end
end
