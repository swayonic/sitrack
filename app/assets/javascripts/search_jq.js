jQuery(document).ready(function() {
	$("#search_options_accordion").accordion({
		collapsible: true,
		active: false,
		autoHeight: false,
		active: 0
	});
	
	$("#options_accordion").accordion({
		collapsible: true,
		active: false,
		autoHeight: false
	});
	
	$(".directory_sidebar_closed").accordion({
		collapsible: true,
		active: false,
		autoHeight: false
	});
	
	$(".directory_sidebar_open").accordion({
		collapsible: true,
		active: false,
		autoHeight: false,
		active: 0
	});
	
	$("#storage_accordion").accordion({
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
	
	initialize_sortable_manage_view_used();
	
	$("#toggle_sidebar").on('click', function(){
		$("div#other_panel").toggle();
		if($("div#other_panel").is(':visible')){
			$("div#main_panel").css('margin-left','220px');
			$("span#sidebar_toggle").html("Hide Sidebar");
		}else{
			$("div#main_panel").css('margin-left','0px');
			$("span#sidebar_toggle").html("Show Sidebar");
		}
	});
	
	$(".button").button();
	
	$("div#directory_tabs").tabs();
	
	$("div#other_panel").fadeIn();
	$("#topnav #left").fadeIn();
	
	$(document).on('change', 'select', function(){ 
		$(this).blur();
	});
	
	$(document).click(function(){
		if(!$("div#ui-datepicker-div").is(':visible')){
			$("input.hasDatepicker").change();
		}
	});
	
	$(".date_select").datepicker({
		changeMonth: true,
		changeYear: true,
		yearRange: '-65:-0',
		onClose: function(){
			$("input.hasDatepicker").change();
		}
	});
});

function initialize_sortable_manage_view_used(){
	$("table.used").sortable({
		items: "tr:not(.not-sortable)",
		update: function(){
			$.ajax({
				type: 'post',
				data: $(this).sortable('serialize'),
				dataType: 'script',
				complete: function(request){
					$(this).effect('highlight');
				},
				url: '/views/reorder_used?id=' + $(this).attr('data-view-id')
			});
		}
	});
  $("table.used").disableSelection();
  $("table.used tr").css("cursor","pointer");
};
