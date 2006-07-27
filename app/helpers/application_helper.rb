# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_option_box(options, name='')
    ret_val = ''
    options.each do |key, value|
      id = name+'_'+key
      checked = @selected_options ? (@selected_options.match(/\[#{id}\]/) ? 'checked="checked"' : '') : ''
      ret_val += "<div class=\"select_item\" onclick=\"check($('#{id}'));\"><input id=\"#{id}\" type=\"Checkbox\" name=\"#{id}\" value=\"#{value}\" title=\"#{value}\" onclick=\"check($('#{id}'));\" #{checked} /> #{value}<br /></div>\n";
    end
    return ret_val
  end
  
  # add underscores
  def u(str)
    str.strip.gsub(/ /, '_')
  end
  
  # check for valid date
  def is_date(value)
    value != '' && value != '1900-01-01 00:00:00' && value != '0000-00-00 00:00:00' && value != '1901-12-13 00:00:00' && value != '1969-12-31 00:00:00'
  end
  
  # format date
  def formatted_date(value=nil)
    ApplicationController::formatted_date(value)
  end
  
  def date_edit_js(column_name, column_id, application_id, value)
    "\"javascript:popCalendar('#{column_name}',#{application_id},#{column_id},'#{value}')\""
  end
  
  def url_for_picture(id, img, size='mini')
    "/files/person/image/#{id}/#{size}/#{img}"
  end
  
    
  # get the name of a project
  def get_project(id)
    self.project(id)
  end
  def self.get_project(id)
    self.project(id)
  end
  
  def self.project(id)
    return '' if  0 == id || id.nil? || '' == id.to_s.strip # an id of 0 is useless. you're useless too
    session[:projects] ||= []
    # early return if we have this project name cached
    return session[:projects][id] if session[:projects][id]
    # if it's not cached, look up the name, cache, and return it.
    project_name = ActiveRecord::Base.connection.select_value("SELECT name FROM #{HrSiProject.table_name} where SIProjectID = #{id}")
    return '' if project_name.nil? || project_name.strip == ''
    session[:projects][id] = project_name
    return project_name
  end
end
