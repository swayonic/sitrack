class JsController < ApplicationController
  caches_page :options
  
  def expire
    expire_page :action => :options
    render :nothing => true
  end
  
  def options
    ret = 'function appendOptions(field, fieldname, value) {'
    ret += "\n switch(fieldname) {"
  	columns = SitrackColumn.find_all_by_column_type('enum')
  	columns.each do |column|
      ret += "\n case '#{column.name}':\n"
      column.sitrack_enum_values.each do |value|
        ret += "\n	var option = document.createElement('option'); "
    		ret += "\n	option.setAttribute('value', '#{value.value}'); "
    		ret += "\n	if ('#{value.value}' == value) { "
    		ret += "\n	option.setAttribute(\"selected\", \"true\"); "
    		ret += "\n	} "
    		ret += "\n	var option_value = document.createTextNode('#{value.name}'); "
    		ret += "\n	option.appendChild(option_value); "
    		ret += "\n	field.appendChild(option); "
      end
  		ret += "\n break;\n";
    end	
    ret += " }\n}"
    ret += "\n"
    ret += 'function appendTeamOptions(field, fieldname, value) {'
    get_teams_ordered.each do |value|
      ret += "\n var option = document.createElement('option'); "
      ret += "\n option.setAttribute('value', '#{value[0]}'); "
      ret += "\n if ('#{value[0]}' == value) { "
      ret += "\n option.setAttribute(\"selected\", \"true\"); "
      ret += "\n } "
      ret += "\n var option_value = document.createTextNode('#{value[1].gsub("'","")}'); "
      ret += "\n option.appendChild(option_value); "
      ret += "\n field.appendChild(option); "
    end 
    ret += " }"
    @out = ret
    render(:layout => false)
  end
end
