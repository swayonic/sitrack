jQuery(document).ready(function() {
	$("#search_options_accordion").accordion({
		collapsible: true,
		active: false,
		autoHeight: false
	});
	
	$(".button").button();
	
	$("div#other_panel").tabs();
});