function change_view()
{
	var f = document.search_f;
	var view = f.view;
	if (view.options[view.selectedIndex].value == '|ev|') {
		document.location = '/views';
		return;
	}
	document.location = '/directory/change_view?view_id=' + view.options[view.selectedIndex].value;
}
function change_region()
{
	var f = document.search_f;
	var region = f.region;
	document.location = '/directory/change_region?region=' + region.options[region.selectedIndex].value;
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
			name = prompt('This list will contain all the people whose names have been checked.\n Please enter a name for this list.','');
			if(name == null) {
			    break;
			} else if (name == '') {
    			alert('Sorry, naming your list is mandatory.');
				save_query(action);
				break;
			}
			f.name.value = name;
			f.action = '/directory/save_query';
			f.submit();
			break;
		case 'append':
			// Display the query selector box
			$('append_query').style.display = "block";
		}

	} else {
		alert("You must select at least one person.");
	}
}
function save_criteria()
{	
    // Make sure we have criteria
    
	// Prompt user for query name
	var name;
	name = prompt('This "Stored Criteria" will store all the search options used in this search.\n Please enter a name for this criteria.','');
	if(name == null) {
	    return;
	} else if (name == '') {
		alert('Sorry, naming your criteria is mandatory.');
		save_criteria();
		return;
	}
	var f = document.participants_f;
	f.name.value = name;
	f.action = '/directory/save_criteria';
	f.submit();
}

function append_query()
{
	var f = document.participants_f;
	// make sure they didn't uncheck all the boxes
	var id_list = get_id_list();
	if (id_list != '0') {
		// set the form action to append_query
		f.action = '/directory/append_query';
		// get the id of the currently selected query
		f.id.value = $('current_query_id').options[$('current_query_id').selectedIndex].value;
		f.id_list.value = id_list;
		f.submit();
	} else {
		alert("You must select at least one person.");
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
		document.location = '/directory/excel_download';
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
		if (value.replace(/s+/gi,'') != '') {
		    new_text = '<a '+href+'>';
		    if ('dollar' == type) {
		      new_text += '$';
		    }
			new_text += value+'</a>';
			item.innerHTML = new_text;
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
	var loc = '/modify/update?value='+value+'&id='+id+'&type='+type+'&colID='+colID+'&fieldname='+fieldname;
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
//Open picture window
function picture_window(personID) {
	var path = "picture.php?personID="+personID+"&action=edit";
	pwin = window.open(path, "pwin", "toolbar=0,scrollbars=0,resizable=1,width=400,height=200");
	pwin.focus();
}

function appendOptions(field, fieldname, value) {
	switch(fieldname) {
    case 'Gender':
		var option = document.createElement('option');
		option.setAttribute('value', '1');
		if ('1' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Male');
		option.appendChild(option_value);
		field.appendChild(option);
		var option = document.createElement('option');
		option.setAttribute('value', '0');
		if ('0' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Female');
		option.appendChild(option_value);
		field.appendChild(option);
    break;
    case 'Staff':
    	var option = document.createElement('option');
    	option.setAttribute('value', '0');
    	if ('0' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('No');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1');
    	if ('1' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Yes');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Marital Status':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'S');
    	if ('S' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Single');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'M');
    	if ('M' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Married');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'D');
    	if ('D' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Divorced');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'P');
    	if ('P' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Seperated');
    	
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'W');
    	if ('W' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Widowed');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Asg Year':
    	var option = document.createElement('option');
    	option.setAttribute('value', '2007-2008');
    	if ('2007-2008' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2007-2008');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2006-2007');
    	if ('2006-2007' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2006-2007');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2005-2006');
    	if ('2005-2006' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2005-2006');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2004-2005');
    	if ('2004-2005' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2004-2005');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2003-2004');
    	if ('2003-2004' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2003-2004');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2002-2003');
    	if ('2002-2003' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2002-2003');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2001-2002');
    	if ('2001-2002' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2001-2002');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2000-2001');
    	if ('2000-2001' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2000-2001');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1999-2000');
    	if ('1999-2000' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('1999-2000');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1998-1999');
    	if ('1998-1999' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('1998-1999');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1997-1998');
    	if ('1997-1998' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('1997-1998');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'App Year':
    	var option = document.createElement('option');
    	option.setAttribute('value', '2007');
    	if ('2007' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2007');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2006');
    	if ('2006' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2006');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2005');
    	if ('2005' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2005');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2004');
    	if ('2004' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2004');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2003');
    	if ('2003' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2003');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2002');
    	if ('2002' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2002');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2001');
    	if ('2001' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2001');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '2000');
    	if ('2000' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('2000');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1999');
    	if ('1999' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('1999');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1998');
    	if ('1998' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('1998');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1997');
    	if ('1997' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('1997');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Status':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Applicant');
    	if ('Applicant' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Applicant');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Ready');
    	if ('Ready' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Ready');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Being Evaluated');
    	if ('Being Evaluated' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Being Evaluated');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Pre A');
    	if ('Pre A' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Pre A');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Accepted');
    	if ('Accepted' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Accepted');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Follow Through');
    	if ('Follow Through' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Follow Through');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Placed');
    	if ('Placed' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Placed');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'On Assignment');
    	if ('On Assignment' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('On Assignment');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Declined');
    	if ('Declined' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Declined');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Withdrawn');
    	if ('Withdrawn' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Withdrawn');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Alumni');
    	if ('Alumni' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Alumni');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Re-Applied');
    	if ('Re-Applied' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Re-Applied');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Terminated');
    	if ('Terminated' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Terminated');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Tenure':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'First Year');
    	if ('First Year' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('First Year');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Second Year');
    	if ('Second Year' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Second Year');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Third Year');
    	if ('Third Year' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Third Year');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Long Term');
    	if ('Long Term' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Long Term');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Intern Type':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'STINT');
    	if ('STINT' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('STINT');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'ICS');
    	if ('ICS' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('ICS');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Internship');
    	if ('Internship' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Internship');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Class B Intern');
    	if ('Class B Intern' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Class B Intern');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Affiliate');
    	if ('Affiliate' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Affiliate');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Region of Origin':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'GL');
    	if ('GL' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('GL');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'GP');
    	if ('GP' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('GP');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'HQ');
    	if ('HQ' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('HQ');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'MA');
    	if ('MA' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('MA');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'MS');
    	if ('MS' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('MS');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'NE');
    	if ('NE' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('NE');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'NW');
    	if ('NW' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('NW');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'RR');
    	if ('RR' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('RR');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'SE');
    	if ('SE' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('SE');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'SW');
    	if ('SW' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('SW');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'UM');
    	if ('UM' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('UM');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'AIA');
    	if ('AIA' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('AIA');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Caring Region':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'GL');
    	if ('GL' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('GL');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'GP');
    	if ('GP' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('GP');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'HQ');
    	if ('HQ' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('HQ');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'MA');
    	if ('MA' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('MA');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'MS');
    	if ('MS' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('MS');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'NE');
    	if ('NE' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('NE');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'NW');
    	if ('NW' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('NW');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'RR');
    	if ('RR' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('RR');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'SE');
    	if ('SE' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('SE');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'SW');
    	if ('SW' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('SW');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'UM');
    	if ('UM' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('UM');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'AIA');
    	if ('AIA' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('AIA');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Asg Team':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'AJN');
    	if ('AJN' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('AJN');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'AQS');
    	if ('AQS' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('AQS');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'AQU');
    	if ('AQU' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('AQU');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'CAR');
    	if ('CAR' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('CAR');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'DES');
    	if ('DES' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('DES');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'JPN');
    	if ('JPN' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('JPN');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'KAZ');
    	if ('KAZ' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('KAZ');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'MEX');
    	if ('MEX' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('MEX');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'ORI');
    	if ('ORI' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('ORI');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'ORS');
    	if ('ORS' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('ORS');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'OZ');
    	if ('OZ' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('OZ');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'PSW');
    	if ('PSW' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('PSW');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'SCO');
    	if ('SCO' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('SCO');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'USI');
    	if ('USI' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('USI');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'WSN');
    	if ('WSN' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('WSN');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'YRR');
    	if ('YRR' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('YRR');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'US Citizen':
        var option = document.createElement('option');
        option.setAttribute('value', '0');
        if ('0' == value) {
        	option.setAttribute("selected", "true");
        }
        var option_value = document.createTextNode('No');
        option.appendChild(option_value);
        field.appendChild(option);
        var option = document.createElement('option');
        option.setAttribute('value', '1');
        if ('1' == value) {
        	option.setAttribute("selected", "true");
        }
        var option_value = document.createTextNode('Yes');
        option.appendChild(option_value);
        field.appendChild(option);
    break;
    case 'Team Leader':
    	var option = document.createElement('option');
    	option.setAttribute('value', '0');
    	if ('0' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('No');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1');
    	if ('1' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Yes');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Needs Debt Check':
    	var option = document.createElement('option');
    	option.setAttribute('value', '0');
    	if ('0' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('No');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', '1');
    	if ('1' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Yes');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
    case 'Future Plans':
		var option = document.createElement('option');
		option.setAttribute('value', 'No Info');
		if ('No Info' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('No Info');
		option.appendChild(option_value);
		field.appendChild(option);
		var option = document.createElement('option');
		option.setAttribute('value', 'Staff');
		if ('Staff' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Staff');
		option.appendChild(option_value);
		field.appendChild(option);
		var option = document.createElement('option');
		option.setAttribute('value', 'Second Year');
		if ('Second Year' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Second Year');
		option.appendChild(option_value);
		field.appendChild(option);
		var option = document.createElement('option');
		option.setAttribute('value', 'Terminate');
		if ('Terminate' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Terminate');
		option.appendChild(option_value);
		field.appendChild(option);
		var option = document.createElement('option');
		option.setAttribute('value', 'Affiliate');
		if ('Affiliate' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Affiliate');
		option.appendChild(option_value);
		field.appendChild(option);
    break;
    case 'Eval Doc Type':
		var option = document.createElement('option');
		option.setAttribute('value', 'Email');
		if ('Email' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Email');
		option.appendChild(option_value);
		field.appendChild(option);
		var option = document.createElement('option');
		option.setAttribute('value', 'Paper');
		if ('Paper' == value) {
			option.setAttribute("selected", "true");
		}
		var option_value = document.createTextNode('Paper');
		option.appendChild(option_value);
		field.appendChild(option);
    break;
    case 'Debt Follow Up':
    	var option = document.createElement('option');
    	option.setAttribute('value', 'No Debt');
    	if ('No Debt' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('No Debt');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Needs Follow Up');
    	if ('Needs Follow Up' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Needs Follow Up');
    	option.appendChild(option_value);
    	field.appendChild(option);
    	var option = document.createElement('option');
    	option.setAttribute('value', 'Cleared');
    	if ('Cleared' == value) {
    		option.setAttribute("selected", "true");
    	}
    	var option_value = document.createTextNode('Cleared');
    	option.appendChild(option_value);
    	field.appendChild(option);
    break;
	}
}