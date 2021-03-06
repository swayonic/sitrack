class ModifyController < ApplicationController
  
  def update
    begin
      value = escape_string(params[:value].to_s.strip)
      type = params[:type]
      if type == 'date'
        value = value.present? ? Date.strptime(value, '%m/%d/%Y').strftime('%Y-%m-%d') : ''
      end
      # if this is an address field from the profile table, handle it differently
      if type == 'address'
        field = params[:fieldname]
        value = Time.parse(value).strftime('%Y-%m-%d') if ['start_date', 'end_date'].include?(field) && value != 'NULL'
        value = value.length > 0 ? "'#{value}'" : 'NULL'
        @sql = "UPDATE #{Address.table_name} "+
               "SET #{field} = #{value}, "+
               "    dateChanged = NOW(), "+
               "    changedBy = 'SITRACK' "+
               "WHERE addressID = #{params[:colID]}"
        @result = ActiveRecord::Base.connection.update(@sql)
        # clear page cache
        Person.find(params[:id]).hr_si_applications.each do |app|
          clear_cache(app.id)
        end
      else
        app_id = params[:id]
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
      	  mpd.touch #stamp the updated_at date
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
      	  queries.each do |sql|
      	    @sql = sql
      	    @result = ActiveRecord::Base.connection.update(sql)
      	  end
      	else
          # Use the select string to figure out which column to update
          # set some default values
          id = app_id  
          where = 'application_id'
          set = ''
        
          value = nil if value && value.empty?
        
          # First, perform some extra logic depeding on which table we're updating
          case table
          when Person.table_name
            value = Person.fix_acct_no(value) if column.id == 2
            value.gsub!(/_/,' ') if value
            person = HrSiApplication.find(app_id).person
            id = person.id
            where = Person.primary_key
            set = ", changedBy = 'SITRACK', dateChanged = NOW() "
            person.hr_si_applications.each do |app|
              clear_cache(app.id)
            end
          when SitrackTracking.table_name
            value.gsub!(/_/,' ') if value
            # make sure they have a tracking row
            SitrackTracking.find(:first, :conditions => ['application_id = ?', app_id]) || SitrackTracking.create(:application_id => app_id)
          when HrSiApplication.table_name
            value.gsub!(/_/,' ') if value
            where = HrSiApplication.primary_key
          when Apply.table_name
            where = HrSiApplication.primary_key
            @sql = "UPDATE #{Apply.table_name} s, #{HrSiApplication.table_name} a  SET s.#{column.select_clause} = #{value ? "'#{value}'" : 'NULL'} #{set} WHERE #{where} = #{id} AND s.id = a.apply_id"
          end
          @sql ||= "UPDATE #{table} SET #{column.select_clause} = #{value ? "'#{value}'" : 'NULL'} #{set} WHERE #{where} = #{id}"
          @result = ActiveRecord::Base.connection.update(@sql)
      	end
        clear_cache(app_id)
      end
      @column = column
    rescue => e
      @error = e
    end
    render :layout => false
  end
  
  private
  # clear page cache
  def clear_cache(id)
    expire_action(:controller => 'profile', :action => 'index', :id => id)
  end
end
