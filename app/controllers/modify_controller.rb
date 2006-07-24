class ModifyController < ApplicationController
  
  def update
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
      raise column.inspect if column.table_clause.nil?
      table = column.table_clause.split(',')[0].constantize.table_name
      # If this is an mpd field, make sure we're entering a numeric value.
    	# there's a list of mpd fields we don't want to force numeric:
    	safe_columns = ['coachName', 'updated_at', 'coachEmail', 'coachPhone', 'coachCell']
    	if (table == SitrackMpd.table_name)
    	  # make sure they have an mpd row
    	  mpd = SitrackMpd.find(:first, :conditions => ['application_id = ?', app_id]) || SitrackMpd.create(:application_id => app_id)
    	  # strip commas and dollar signs
  		  value = value.scan(/\d/).join unless safe_columns.include?(column.select_clause)
        value = nil if value == ''
  		end
    	# If we have an update clause, use it
    	if (column.update_clause && column.update_clause != '')
    	  #replace table names
    	  column.update_clause.gsub!(/\$table_mpd/,SitrackMpd.table_name)
        column.update_clause.gsub!(/\$table_address/,Address.table_name)
    	  # replace question marks
    	  column.update_clause.sub!(/\?/, value ? "'"+value.to_s+"'" : 'NULL') # the first question mark is the value
        # If this is an address, use the person id instead of the application id
    		if Address.table_name == table
    			# Get the person id
    			application = HrSiApplication.find(app_id)
    			id = application.fk_personID
    		else 
    		  id = app_id
    		end
        column.update_clause.gsub!(/\?/, id.to_s) # the rest are the id
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
        value.gsub!(/_/,' ')
        @sql = "UPDATE #{table} SET #{column.select_clause} = #{value ? "'#{value}'" : NULL} #{set} WHERE #{where} = #{id}"
        @result = ActiveRecord::Base.connection.update(@sql)
    	end
    end
    # clear page cache
    expire_action(:controller => 'profile', :action => 'index', :id => app_id)
    @column = column
    render :layout => false
  end

end
