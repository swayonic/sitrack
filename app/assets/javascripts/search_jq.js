jQuery(document).ready(function() {
	$("#search_options_accordion, #options_accordion, #storage_accordion").accordion({
		collapsible: true,
		active: false,
		autoHeight: false
	});
	
	$('#list_append_dialog').dialog({
		resizable: false,
		height: 150,
		modal: true,
		draggable: false,
		autoOpen: false,
		buttons: [
    	{ text: "Close", click: function() {$(this).dialog("close");} },
    	{ text: "Append", click: function() {append_query();} }
    ]
	});
	
	$(".button").button();
	
	$("div#other_panel").tabs();
	
	$("div#other_panel").fadeIn();
	
	$(".date_select").datepicker();
});