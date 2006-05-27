# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_option_box(options, prefix='')
    ret_val = ''
    options.each do |key, value|
      key = prefix+key
      ret_val += "<div class=\"select_item\" onclick=\"check(document.search_f['#{key}']);\"><input type=\"Checkbox\" name=\"#{key}\" value=\"#{value}\" title=\"#{value}\" onclick=\"check(document.search_f['#{key}']);\" $check> #{value}<br /></div>\n";
    end
    return ret_val
  end
  
  def app_years
  	years = []
    (2003..Time.now.year).sort{|a,b| b<=>a}.each do |year|
      years << ['y'+year.to_s,year]
  	end
  	return years
  end
end
