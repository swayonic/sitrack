class JsController < ApplicationController
  caches_page :options
  def options
    @out = 'function appendOptions(field, fieldname, value) {'
    @out += "\n switch(fieldname) {"
  	columns = SitrackColumn.find_all_by_column_type('enum')
  	columns.each do |column|
      @out += "\n case '#{column.name}':\n"
      column.sitrack_enum_values.each do |value|
        @out += "\n	var option = document.createElement('option'); "
    		@out += "\n	option.setAttribute('value', '#{value.value}'); "
    		@out += "\n	if ('#{value.value}' == value) { "
    		@out += "\n	option.setAttribute(\"selected\", \"true\"); "
    		@out += "\n	} "
    		@out += "\n	var option_value = document.createTextNode('#{value.name}'); "
    		@out += "\n	option.appendChild(option_value); "
    		@out += "\n	field.appendChild(option); "
      end
  		@out += "\n break;\n";
    end	
    @out += " }\n}"
    @out += "\n"
    @out += 'function appendTeamOptions(field, fieldname, value) {'
    get_teams_ordered.each do |value|
      @out += "\n var option = document.createElement('option'); "
      @out += "\n option.setAttribute('value', '#{value[0]}'); "
      @out += "\n if ('#{value[0]}' == value) { "
      @out += "\n option.setAttribute(\"selected\", \"true\"); "
      @out += "\n } "
      @out += "\n var option_value = document.createTextNode('#{value[1].gsub("'","")}'); "
      @out += "\n option.appendChild(option_value); "
      @out += "\n field.appendChild(option); "
    end 
    @out += " }"

    render(:layout => false)
  end
end
