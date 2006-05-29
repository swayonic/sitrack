function change_view()
{
	var f = document.search_f;
	var view = f.view;
	if (view.options[view.selectedIndex].value == '|ev|') {
		document.location = '/views';
		return;
	}
	document.location = 'directory?view_id=' + view.options[view.selectedIndex].value;
}
function change_region()
{
	var f = document.search_f;
	var region = f.region;
	document.location = 'directory.php?region=' + region.options[region.selectedIndex].value;
}

function save_query(action)
{	
	var f = document.participants_f;
	var id_list = get_id_list();
	if (id_list != '0') {
		f.id_list.value = id_list;
		// figure out if we're creating a new query or appending
		switch (action)	{
		case 'new':
			// Prompt user for query name
			var name;
			name = prompt('This query will contain all the people whose names have been checked.\n Please enter a name for this query.','');
			if(!name) {
				break;
			}
			f.queryName.value = name;
			f.action.value = 'save_query';
			f.submit();
			break;
		case 'append':
			// Display the query selector box
			show('append_query');
		}

	} else {
		alert("You must select at least one person.");
	}
}
function save_criteria()
{	
	var f = document.participants_f;
	// Prompt user for query name
	var name;
	name = prompt('This "Stored Criteria" will store all the search options used in this search.\n Please enter a name for this criteria.','');
	if(!name) {
		return;
	}
	f.criteriaName.value = name;
	f.action.value = 'save_criteria';
	f.submit();
}

function append_query()
{
	var f = document.participants_f;
	// make sure they didn't uncheck all the boxes
	var id_list = get_id_list();
	if (id_list != '0') {
		// set the form action to append_query
		f.action.value='append_query';
		// get the id of the currently selected query
		f.queryID.value = f.append_query.options[f.append_query.selectedIndex].value;
		f.id_list.value = id_list;
		f.submit();
	} else {
		alert("You must select at least one person.");
	}
}

function delete_query(query, queryID)
{	
	var f = document.participants_f;
	if (confirm('Are you sure you want to delete the "'+query+'" query?')) {
		f.action.value = 'delete_query';
		f.queryID.value = queryID;
		f.submit();
	}
}

function delete_criteria(criteria, criteriaID)
{	
	var f = document.participants_f;
	if (confirm('Are you sure you want to delete the "'+criteria+'" criteria?')) {
		f.action.value = 'delete_criteria';
		f.criteriaID.value = criteriaID;
		f.submit();
	}
}

function get_id_list()
{
	var f = document.participants_f;
	var id_list = '0';
	if (f["id_array[]"]) {
		if (f["id_array[]"].length) {
			for(i=0; i<f["id_array[]"].length; i++) {
				if (f["id_array[]"][i].checked == true)
					id_list = id_list + ',' + f["id_array[]"][i].value;
			}
		} else {
			if (f["id_array[]"].checked == true)
				id_list = id_list + ',' + f["id_array[]"].value;
		}
	}
	return id_list;
}

function checkAll() 
{
	f = document.participants_f;
	if (f.all.checked == true) {
		if (f["id_array[]"]) {
			if (f["id_array[]"].length) {
				for(i=0; i<f["id_array[]"].length; i++) {
					f["id_array[]"][i].checked = true;
				}
			} else {
				f["id_array[]"].checked = true;
			}
		}
	} else {
		if (f["id_array[]"]) {
			if (f["id_array[]"].length) {
				for(i=0; i<f["id_array[]"].length; i++) {
					f["id_array[]"][i].checked = false;
				}
			} else {
				f["id_array[]"].checked = false;
			}
		}
	}
}
function perform_action()
{
	var f = document.search_f;
	var action = f.do_something.options[f.do_something.selectedIndex].value;
	f.do_something.selectedIndex = 0;
	var count = 0;
	// perform the action selected
	switch (action)	{
	case 'email':
		var punc = ';'
		// concat the emails for each checked person
		f = document.participants_f;
		var email_list = '';
		if (f["id_array[]"]) {
			if (f["id_array[]"].length) {
				for(i=0; i<f["id_array[]"].length; i++) {
					if (f["id_array[]"][i].checked == true && f['e'+f["id_array[]"][i].value].value != '') {
						email_list = email_list + punc + f['e'+f["id_array[]"][i].value].value;
						count++;
						if (count == 75) {
							break;
						}
					}
				}
			} else {
				if (f["id_array[]"].checked == true)
					email_list = email_list + punc + f['e'+f["id_array[]"].value].value;
			}
		}
		if (email_list == '') {
			alert('You must select at least one person to email.');
		} else {
			if (count == 75) {
				alert('WARNING: This email is only being sent to the first 75 people you selected.');
			}
			document.location = 'mailto:?bcc='+email_list;
			return;
		}
		break;
	case 'excel':
		document.location = 'create_excel.php';
		return;
		break;
	case 'delete':
		var id_list = get_id_list();
		if (id_list != '0') {
			var f = document.participants_f;
			f.id_list.value = id_list;
			f.action.value = 'delete_prompt';
			f.submit();
		} else {
			alert('You did not select anyone to delete.');
		}
		break;
	}
}

// Set Netscape up to run the "captureMousePosition" function whenever
// the mouse is moved. For Internet Explorer and Netscape 6, you can capture
// the movement a little easier.
if (document.layers) { // Netscape
    document.captureEvents(Event.MOUSEMOVE);   
}
function appendField(fieldname, id, value, colID, type, selectClause)
{
	var f = document.participants_f;
	switch (type) {
	case 'text':
		var field = document.createElement("textarea");
		//field.defaultValue = value;
		field.innerHTML = value;
		break;
	case 'enum':
		var field = document.createElement("select");
		appendOptions(field, fieldname, value);
		field.onchange = function () {
						this.blur();
					}
		break;
	default:
		var field = document.createElement("input");
		field.setAttribute('type', 'text');
		field.setAttribute('value', value);
		field.setAttribute('size', '10');
		field.setAttribute('maxlength','50');
		field.onkeydown = function (event) {
							check_key(event,value,fieldname, id, colID, type, selectClause);
						}
		break;
	}
	field.setAttribute('name', fieldname+id+'c'+colID);
	field.setAttribute('id', 'v'+fieldname+id+'c'+colID);
	field.onblur = function () {
						update_value(fieldname, id, colID, type, selectClause);
					}

	var c = document.createElement('div');
	c.setAttribute('id', 'f'+fieldname+id+'c'+colID);
	c.setAttribute('class', 'modify_field');
	c.appendChild(field);
	
	var outer = document.getElementById('c'+fieldname+id+'c'+colID);
	outer.appendChild(c);
			
}
function edit_value(fieldname, id, value, colID, type, selectClause, skipAppend)
{
	var f = document.participants_f;
	if (!skipAppend) {
		appendField(fieldname, id, value, colID, type, selectClause);
	}
	document.getElementById(fieldname+id+'c'+colID).style.display = "none";
	document.getElementById('f'+fieldname+id+'c'+colID).style.display = "inline";
	document.getElementById('v'+fieldname+id+'c'+colID).focus();
}
function update_value(fieldname, id, colID, type, selectClause)
{	
	var f = document.participants_f;
	var frame = window.frames["modify_frame"];
	// Put the right value in the blank
	var item = document.getElementById(fieldname+id+'c'+colID);
	var value = document.getElementById('v'+fieldname+id+'c'+colID).value
	var rExp = new RegExp("\'", "g"); 
	var js_value = value.replace(rExp, "\\\'");
	var params = "'"+fieldname+"','"+id+"','"+js_value+"','"+colID+"','"+type+"','"+selectClause+"','true'";
	var href = 'href="javascript:edit_value('+params+')"';
	switch (type) {
	case 'text':
		if (value.length > 30) {
			short_value = value.slice(0,27) + '...';
		} else {
			short_value = value;
		}
		if (short_value != '' && short_value != '...') {
			//alert('-'+short_value+'-');
			new_text = '<a '+href+' onclick="nd();" onmouseover="return overlib(\''+value+'\',LEFT);" onmouseout="nd();">'+short_value+'</a>';
		} else {
			new_text = '<a '+href+'><img src="/images/edit.png" border="0"/> </a>';
		}
		item.innerHTML = new_text;
		break;
	case 'enum':
		var field = document.getElementById('v'+fieldname+id+'c'+colID);
		//alert(field);
		var value = field[field.selectedIndex].value;	// Redefine value
		var text = field[field.selectedIndex].text;
		var params = "'"+fieldname+"','"+id+"','"+value+"','"+colID+"','"+type+"','"+selectClause+"','true'";	// Redefine params
		var href = 'href="javascript:edit_value('+params+')"'; // Redefine href
		item.innerHTML = '<a id="link'+fieldname+id+'c'+colID+'" '+href+'>'+text+'</a>';
		break;
	default: 
		if (value && ' ' != value) {
			item.innerHTML = '<a '+href+'>'+value+'</a>';
		} else {
			item.innerHTML = '<a '+href+'><img src="/images/edit.png" border="0"/></a>';
		}
		break;
	}
	// hide the form field
	document.getElementById('f'+fieldname+id+'c'+colID).style.display = "none";
	// show the value
	item.style.display = "inline";
	// use the iframe
	value = escape(value);
	var loc = 'modify_value.php?value='+value+'&id='+id+'&type='+type+'&colID='+colID+'&fieldname='+fieldname;
	if (selectClause) {
		loc += '&selectClause='+selectClause
	}
	frame.document.location = loc;
}
function check_key(event, old_value, fieldname, id, colID, type, selectClause)
{
	if (document.all) {
		key = window.event.keyCode;
	} else {
        key = event.which;
    }
	// if enter is pressed save
	if (key == 13) {
		// blur it
		document.getElementById('v'+fieldname+id+'c'+colID).blur();
		return;
	// if escape is pressed cancel
	} else if (key == 27) {
		// reset the value
		document.getElementById('v'+fieldname+id+'c'+colID).value = old_value;
		// blur it
		document.getElementById('v'+fieldname+id+'c'+colID).blur();
		return;
	}
	//window.status = "key=" + key;
}