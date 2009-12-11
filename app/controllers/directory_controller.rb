class DirectoryController < ApplicationController
  
  def index
    show_directory
  end       
  
  def show_directory
    @views = sitrack_user.sitrack_views
    @regions = SitrackRegion.all
    # look for a view_id stored in the session
    @view_id = sitrack_session.get_value('view_id')
    # use find_by_id here instead of just find so that it doesn't error out if the view doesn't exist
    @view = SitrackView.find_by_id(@view_id, :include => {:sitrack_view_columns => :sitrack_column}, :order => 'sitrack_view_columns.position')
    unless @view
      # # set up the view
      # begin
      #   
      # rescue
      #   view_sess_obj = nil
      # end
      @view = sitrack_user.sitrack_views.find(:first, :include => {:sitrack_view_columns => :sitrack_column})
      unless @view
        UserController.create_views(sitrack_user)
        @view = sitrack_user.sitrack_views.find(:first, :include => {:sitrack_view_columns => :sitrack_column})
      end
      @view_id = @view.id
      sitrack_session.save_value('view_id', @view_id) 
      @view ||= SitrackView.find(@view_id, :include => {:sitrack_view_columns => :sitrack_column}, :order => 'sitrack_view_columns.position')
    end
    # @template_name = "results#{@view_id}"
    # @template_with_path = "#{RAILS_ROOT}/app/views/directory/_#{@template_name}.rhtml"
    # unless File.exist?(@template_with_path)
    #   template = render_to_string(:partial => 'results_template')
    #   File.open(@template_with_path, 'w') do |f|
    #     f.puts template
    #   end
    # end

    # if we have a query_id in the session, use the saved list
    if (query_id = sitrack_session.get_value('query_id'))
      @current_query = SitrackQuery.find_by_id(query_id)
      if (@current_query)
        @where_clause = ' applicationID IN('+@current_query.persons+') ' 
        @selected_options = nil
      end
    end
    
    # if we have a criteria_id in the session, use the saved query
    if (criteria_id = sitrack_session.get_value('criteria_id'))
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
    
    
    @saved_queries = SitrackQuery.find_all_by_owner(sitrack_user.id, :order => :name)
    @saved_criteria = SitrackSavedCriteria.find_all_by_owner(sitrack_user.id, :conditions => 'saved = 1', :order => :name)
    @sel_region_name ||= '%'
    
    # get the search options
    @options = get_options
    @options_hash = get_option_hash
    @teams = get_teams
    @teams_ordered = get_teams_ordered
    
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
        query_string[:status] += join + Apply.table_name + ".status = '#{status[0]}'"
        @selected_options += "[status_#{status[0]}]"
      end
    end
    query_string[:status] += ')' unless query_string[:status] == ''
    
    
    ## Intern Type
    @options['Intern Type'].each do |type|
      if params['intern_type_'+type[0]]
        join = (query_string[:type] == '') ? ' AND (' : ' OR '
        query_string[:type] += join + SitrackTracking.table_name + ".internType = '#{type[1]}'"
        @selected_options += "[intern_type_#{type[0]}]"
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
    @criteria = SitrackSavedCriteria.create(:owner => sitrack_user.id, :criteria => @qs, :options => @selected_options)
    # put the criteria in the session
    sitrack_session.save_value('criteria_id',@criteria.id)
    # remove any query_id. You can't use a criteria and query at the same time.
    sitrack_session.remove_value('query_id')
    show_directory
  end
  
  def show_query
    query_id = params[:id]
    # if we don't have a query id, just show the directory
    if query_id
      sitrack_session.save_value('query_id', query_id)
      # clear any unsaved stored criteria
      sitrack_session.remove_value('criteria_id')
      SitrackSavedCriteria.delete_all("owner = #{sitrack_user.id} AND saved = 0")
    end
    show_directory
  end
  
  def show_criteria
    criteria_id = params[:id]
    # if we don't have a criteria id, just show the directory
    if criteria_id
      sitrack_session.save_value('criteria_id', criteria_id)
      # remove any query_id. You can't use a criteria and query at the same time.
      sitrack_session.remove_value('query_id')
    end
    show_directory
  end
  
  def delete_query
    # make sure they own the query
    query = SitrackQuery.find_by_owner_and_id(sitrack_user.id, params[:id])
    query.destroy if query
    index
  end
  
  def delete_criteria
    # make sure they own the query
    criteria = SitrackSavedCriteria.find_by_owner_and_id(sitrack_user.id, params[:id])
    criteria.destroy if criteria
    index
  end
  
  def save_query
    if request.post? && params[:name] && params[:id_list]
      query = SitrackQuery.create(:name => params[:name], :owner => sitrack_user.id, :persons => params[:id_list])
      sitrack_session.save_value('query_id', query.id)
    end
    show_directory
  end
  
  def append_query
    if request.post? && params[:id] && params[:id_list]
      # make sure they own this query
      query = SitrackQuery.find_by_owner_and_id(sitrack_user.id, params[:id])
      if query
        curr_list = query.persons.split(',')
        add_list = params[:id_list].split(',')
        query.persons = (curr_list + add_list).uniq.join(',')
        query.save! 
        sitrack_session.save_value('query_id', query.id)
      end
    end
    show_directory   
  end
  
  def save_criteria
    if request.post? && params[:name] && (id = sitrack_session.get_value('criteria_id'))
      criteria = SitrackSavedCriteria.find(id)
      criteria.name = params[:name]
      criteria.saved = 1
      criteria.save!
    end
    show_directory
  end
  
  def change_region
    sitrack_session.save_value('region', params[:region]) if params[:region]
    show_directory
  end
  
  def change_view
    view_id = params[:view_id].to_i
  	# save view in session object
  	sitrack_session.save_value('view_id', view_id) if view_id != 0
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
  
#  def fix_criteria
#    @options_hash = get_option_hash
#    @criteria = SitrackSavedCriteria.find_all
#    @criteria.each do |c|
#      ['Status', 'Intern Type', 'Position', 'Tenure', 'App Year'].each do |field|
#        raise field.inspect unless @options_hash[field]
#        @options_hash[field].each do |value|
#          c.options.gsub!('['+value[1]+']', '['+u(field.downcase)+'_'+value[0]+']')
#        end
#      end
#      c.options.gsub!('[o_', '[region_of_origin_')
#      c.options.gsub!('[c_', '[caring_region_')
#      c.options.gsub!('[y','[app_year_')
#      c.options.gsub!('[team_leader]','[misc_team_leader]')
#      c.options.gsub!('[monthly_birthday]','[misc_monthly_birthday]')
#      c.options.gsub!('[staff]','[position_1]')
#      c.options.gsub!('[not_staff]','[position_0]')
#      
#      # fix criteria
#      c.criteria.gsub!('t.', 'sitrack_tracking.')
#      c.criteria.gsub!('l.', 'hr_si_applications.')
#      c.criteria.gsub!('p.', 'ministry_person.')
#      c.save!
#    end
#    render_nothing
#  end
  
  def excel_download
    if request.post?
      #get the view
      @view = SitrackView.find(sitrack_session.get_value('view_id'), 
                              :include => [:sitrack_view_columns, :sitrack_columns], 
                              :order => 'sitrack_view_columns.position')
      # figure out what to call the downlaod
      if params[:id_list] && params[:id_list] != ''
        @where_clause = " #{HrSiApplication.table_name}.applicationID in( #{params[:id_list]} ) "
      elsif (id = sitrack_session.get_value('query_id'))
        query = SitrackQuery.find(id)
        name = query.name
        @where_clause = " #{HrSiApplication.table_name}.applicationID in( #{query.persons} ) "
      elsif (id = sitrack_session.get_value('criteria_id'))
        criteria = SitrackSavedCriteria.find(id)
        name = criteria.name
        @qs = criteria.criteria
      end
      name = @view.name if !name || name.empty?
      where ||= ''
      
      build_query
      
      @options_hash = get_option_hash
      @teams = get_teams
      
#      headers['Content-Type'] = "application/vnd.ms-excel" 
      headers['Content-Type'] = "text/tab-separated-values" 
      headers['Content-Disposition'] = "attachment; filename=\"#{name}.xls\""
      headers['Cache-Control'] = ''
      @sheet = ''
      @view.sitrack_view_columns.each do |vc|
        column = vc.sitrack_column
        @sheet += column.name+"\t"
      end
      @sheet += "\n"
      @people.each do |person|
        @view.sitrack_view_columns.each do |vc|
          column = vc.sitrack_column
          value = person[column.safe_name] || ''
          raise column.safe_name.inspect if value.nil?
          case column.column_type
          when 'date'
            value = ApplicationController.formatted_date(value) 
          when 'enum'
            value = @options_hash[column.name][u(value)]
          when 'project'
            value = get_project(value.to_i)
          when 'team'
            value = @teams[value]
          end
          @sheet += "#{value}\t"
        end
        @sheet += "\n"
      end
      render :layout => false
    end
  end
  
  #####################
  ##### PRIVATE #######
  #####################
  private
  #########################      
  #### Query           ####
  #########################
  def build_query
    @sel_region_name = sitrack_session.get_value('region') || current_user.person.region
    @sel_region_name = '%' if @sel_region_name == 'all'
    all_where = ""
    all_where = "( #{Person.table_name}.region LIKE '#{@sel_region_name}' OR #{SitrackTracking.table_name}.caringRegion LIKE '#{@sel_region_name}' ) "+
			     "AND (#{Person.table_name}.firstName <> '' OR #{Person.table_name}.lastName <>'' )" if @sel_region_name
    select_clause = @view.display_columns
    from_clause = SitrackView.join_tables
    @where_clause = all_where unless @where_clause
    @sql = 'SELECT '+select_clause+' FROM '+from_clause+' WHERE '+@where_clause
    
    # Remove first "AND" if there's no where_clause
    if @where_clause.blank?
      @qs.sub!("AND", "") if @qs
    end
    
    # If we have a search or saved criteria, add the query string.
    @sql += @qs if @qs
    @order_by = get_order_by(@view)
    @people = ActiveRecord::Base.connection.select_all(@sql+' ORDER BY '+@order_by)
  end
  
  # Replace spaces with underlines
  def u(str)
    str.strip.gsub(/ /, '_')
  end
  
  def get_order_by(view)
    # if there is a query id in the params, set the session value
    if (params[:order_by])
      order_by = params[:order_by]
      sitrack_session.save_value('order_by', order_by)
    end
    # if we have a order_by in the session, use it
    order_by = sitrack_session.get_value('order_by')
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
