var option_arr = new Array('statuses','types','positions','tenures','miscs','rogs','crs','years');
var menu_arr = new Array('status','type','position','tenure','misc','rog','cr','year');
var current;

//this function will align the menu-bar in the proper position on the page
function align_menu() {
	var v_adj = 36;
	var h_adj = 127;

	// Establish staring point
	var curr_loc = document.getElementById("options").offsetLeft + document.getElementById("options").offsetWidth + 4;
	var top_menu = document.getElementById("options").offsetTop + 'px';
	var bottom_menu = document.getElementById("options").offsetTop + document.getElementById("options").offsetHeight + 3 + 'px';
	var rows = 1;

	// Make box appear with selected items, and align it.
	document.getElementById("selected_options").style.top = bottom_menu;
	document.getElementById("selected_options").style.left = -5 + document.getElementById("options").offsetLeft + 'px';
//	document.getElementById("selected_options").style.display = 'none';
	if (selected(document.forms[0])) {
		// If options are selected, hide the box
		//		show("selected_options");
	}

	// set up each section
	for (x=0; x<option_arr.length; x++) {
		// after 5 items, start at the next row down
		if (x!=0 && x % 5 == 0) {
			top_menu = document.getElementById(menu_arr[x-1]).offsetTop + document.getElementById(menu_arr[x]).offsetHeight + 10 + 'px';
			bottom_menu = v_adj + document.getElementById(option_arr[x-1]).offsetTop + document.getElementById(menu_arr[x]).offsetHeight + 45 + 'px';
			curr_loc = document.getElementById("options").offsetLeft + document.getElementById("options").offsetWidth + h_adj;
			rows++;
		}
		document.getElementById(menu_arr[x]).style.top = top_menu;
		document.getElementById(menu_arr[x]).style.left = curr_loc + 'px';
		document.getElementById(option_arr[x]).style.top = bottom_menu;
		document.getElementById(option_arr[x]).style.left = curr_loc + 2 + 'px';
		document.getElementById(option_arr[x]).style.display = 'none';
		if (document.getElementById(option_arr[x]).offsetWidth < 110) {
			document.getElementById(option_arr[x]).style.width = '115px';
		}
		
		// increase curr_loc
		curr_loc += Math.max(document.getElementById(option_arr[x]).offsetWidth, document.getElementById(menu_arr[x]).offsetWidth) ;
	}
	// tack the name option on the bottom
	top_menu = document.getElementById(menu_arr[menu_arr.length-1]).offsetTop + document.getElementById(menu_arr[menu_arr.length-1]).offsetHeight + 10 + 'px';
	curr_loc = document.getElementById("options").offsetLeft + document.getElementById("options").offsetWidth + h_adj;
	rows++;

	document.getElementById('name').style.top = top_menu;
	document.getElementById('name').style.left = curr_loc + 'px';

	// resize the search options box
	document.getElementById('search').style.height = 26 * rows + 'px';

}
function show_me(item) {
    if (item && $(item)) {
    	var ptr = $("#"+item);
    	var action_ptr = $('#action_menu');

    	// hide the previous item (if any), then show the one clicked
    	// if this was the last item clicked, switch it's display
    	if (item == current) {
    		ptr.hide();
    		current = '';
    		// display the action menu
    		// action_ptr.show();
    		return;
    	}
    	// hide old item
    	if ($(current)) {
    		$(current).hide();
    	}
    	// display current item
    	if (ptr) {
    		ptr.show();
    	}
    	current = item;
    	// hide the action menu
    	// action_ptr.hide();
    }
}
function hide_menu(event){
	captureMousePosition(event)
	// check to see if the mouse is currently over the current menu
	if ($(current)) {
		var ptr = $(current);
		// mouse position is tracked by a function in general.js
		// get the box boundries
		var pad = 0;
		var left = ptr.offsetLeft + pad;
		var right = ptr.offsetLeft + ptr.offsetWidth - pad;
		var top = ptr.offsetTop - pad;
		var bottom = ptr.offsetTop + ptr.offsetHeight - pad;
		// if mouse is not in this area, hide the menu
		if (xMousePos < left || xMousePos > right || yMousePos < top || yMousePos > bottom) {
			show_me(current);
		}
	}
}

function show(item) {
	var ptr = document.getElementById(item);
	if (ptr.style.display == "none") {
		ptr.style.display = "block";
	} else {
		ptr.style.display = "none";
	}
}

function check(item) {
	if (item.checked) {
		item.checked = false;
	} else {
		item.checked = true;
	}
	selected(item);
}

function toggle(item) {
	print_selected(true);
}

function print_selected(show_apply){
	var selected_options = '';
	var title = '';
	var fields = $('.option_box');
	var active = 0;
	for(var i=0; i < fields.length; i++){
		var field = fields.eq(i);
		print_entry = false;
		print_label = false;
		if(field.attr('type').toLowerCase() == 'checkbox'){
			if(field.is(':checked')){
				if(title != field.attr('group')){
					print_label = true;
				}
				print_entry = true;
				active += 1;
			}
		}
		if(field.attr('type').toLowerCase() == 'text'){
			if(field.val()){
				if(title != field.attr('group')){
					print_label = true;
				}
				print_entry = true;
				active += 1;
			}
		}
		if(print_label){
			selected_options += "<div class='label'>" + field.attr('group') + ":</div>";
			title = field.attr('group');
		}
		if(print_entry){
			selected_options += "<div class='entry'>";
				selected_options += field.attr('title');
				selected_options += "<div class='entry_delete'>";
					selected_options += "<img src='/assets/x.png' onclick=\"remove_selected($('#"+field.attr('id')+"'))\">";
				selected_options += "</div>";
			selected_options += "</div>";
		}
	}
	if(show_apply){
		active += 1;
		selected_options += "<center><br/><a href='javascript:document.search_f.submit();' id='apply_selected' class='button'>Apply Changes</a></center>";
	}
	
	if(active == 0){
		$('#selected_options').html("");
	}else{
		div_selected_options = "<div id='advance_search_options' class='filter_tab padb3'>";
			div_selected_options += "<h3><a href='#'>Active Search Options</a></h3>";
			div_selected_options += "<div>";
				div_selected_options += selected_options;
			div_selected_options += "</div>";
		div_selected_options += "</div>";
		$('#selected_options').html(div_selected_options);
		$('#apply_selected').button();
		$("#advance_search_options").accordion({
			collapsible: true,
			active: false,
			autoHeight: false,
			active: 0
		});
	}
}

function remove_selected(field){
	if(field.attr('type').toLowerCase() == 'text'){
		field.val("");
	}
	if(field.attr('type').toLowerCase() == 'checkbox'){
		field.attr('checked', false)
	}
	print_selected(true);
}

function selected(form) {
	var selected_options = '';
	var titles = '';
	// loop over entire form checking for all values
	
	for (var i=0; i < form.length; i++) {
		var item = form[i];
		if (item.attr('type') == 'text') {
			if (item.val()) {
				selected_options += '<div class="subboxheader">' + item.attr('title') + '</div>';
				selected_options += '<div class="menu">' + item.val() + '</div>';
			}
		} else if (item.attr('type') == 'checkbox') {
			if (item.is(':checked')) {
				title = item.parent('form').attr('title');
				if (titles.lastIndexOf(title) == -1) {
					selected_options += '<div class="subboxheader">' + title + '</div>';
					titles = titles+','+title;
				}
				obj = "uncheck($(\'#"+item.name+"\'))";
				selected_options += "<div class='menu'><img class='x2' onclick="+obj+" src='/assets/x.png' alt='Remove' title='Remove'>" + item.title + "</div>";
			}
		}
	}
}

function clear_form()
{
	// loop over entire form clearing all values
	var fields = $('.option_box');
	for (var i=0; i<fields.length; i++) {
		var field = fields.eq(i);
		// Clear text fields
		if (field.attr('type').toLowerCase() == 'text') {
			field.val('');
		}
		// Clear all the checkboxes
		else if (field.attr('type').toLowerCase() == 'checkbox') {
			field.attr('checked', false);
		}
	}
	
	div_selected_options = "<div id='advance_search_options' class='filter_tab padb3'>";
		div_selected_options += "<h3><a href='#'>Active Search Options</a></h3>";
		div_selected_options += "<div>";
			div_selected_options += "<center><br/><a href='javascript:document.search_f.submit();' id='apply_selected' class='button'>Apply Changes</a></center>";
		div_selected_options += "</div>";
	div_selected_options += "</div>";
	$('#selected_options').html(div_selected_options);
	$('#apply_selected').button();
	$("#advance_search_options").accordion({
		collapsible: true,
		active: false,
		autoHeight: false,
		active: 0
	});
}

function clear_search()
{
	clear_form();
}

function uncheck(item)
{
	item.attr('checked', false);
	selected(item);
}

function enterCheck(form)
{
	if (key == '13') {
		form.submit();
	}
}

$()

