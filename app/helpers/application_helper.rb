module ApplicationHelper

  def display_option_box(options, name='')
    ret_val = ''
    options.each do |key, value|
      id = name+'_'+key
      checked = @selected_options ? (@selected_options.match(/\[#{id}\]/) ? 'checked="checked"' : '') : ''
      ret_val += "<div class=\"select_item\" onclick=\"check($('#{id}'));\"><input id=\"#{id}\" type=\"Checkbox\" name=\"#{id}\" value=\"#{key}\" title=\"#{value}\" onclick=\"check($('#{id}'));\" #{checked} /> #{value}<br /></div>\n";
    end unless options.blank?
    return ret_val
  end
  
  # add underscores
  def u(str)
    str.to_s.strip.gsub(/ /, '_')
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
    "javascript:popCalendar('#{column_name}',#{application_id},#{column_id},'#{value}')"
  end
  
  def url_for_picture(id, img, size='mini')
    "/files/person/image/#{id}/#{size}/#{img}"
  end
  
    
  # get the name of a project
  def get_project(id)
    controller.get_project(id)
  end
end
