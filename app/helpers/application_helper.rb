# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_option_box(options, name='')
    ret_val = ''
    options.each do |key, value|
      id = name+'_'+key
      ret_val += "<div class=\"select_item\" onclick=\"check($('#{id}'));\"><input id=\"#{id}\" type=\"Checkbox\" name=\"#{id}\" value=\"#{value}\" title=\"#{value}\" onclick=\"check($('#{id}'));\" /> #{value}<br /></div>\n";
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
  
  def in_place_select_editor_field(object,
                                   method,
                                   tag_options = {},
                                   in_place_editor_options = {})
    tag = ::ActionView::Helpers::InstanceTag.new(object, method, self)
    tag_options = { :tag => "span",
                    :id => "#{object}_#{method}_#{tag.object.id}_in_place_editor",
                    :class => "in_place_editor_field"}.merge!(tag_options)
    in_place_editor_options[:url] ||=
        url_for({ :action => "set_#{object}_#{method}", :id => tag.object.id })
    tag.to_content_tag(tag_options.delete(:tag), tag_options) +
    in_place_select_editor(tag_options[:id], in_place_editor_options)
  end
  
  def in_place_select_editor(field_id, options = {})
    function = "new Ajax.InPlaceSelectEditor("
    function << "' #{field_id}' , "
    function << "' #{url_for(options[:url])}' "
    function << (' , ' + options_for_javascript(
      {
        ' selectOptionsHTML' =>
              %(' #{escape_javascript(options[:select_options].gsub(/\n/, ""))}' )
      }
      )
    ) if options[:select_options]
    function << ' )'
    javascript_tag(function)
  end
end
