// The concept for all this swap stuff, and some of the code should be
// attributed to Sandy Yu: sandywyu at gmail dot com
var move_buttons = "";  //element we're using button controls to move
function submit_form()
{
	var elem;
	var good = false;
	if (document.view_form.view_name.value == '') {
		alert("You must name this view.");
		return;
	}
	document.view_form.submit();
}
function move_to_top()
{
	var f = document.view_form;
	var pos = 10000;
	// make sure something has been selected
	if (!move_buttons) {
		alert('Row not selected');
		return;
	}
	var max_pos = 1;
	// set skip variable to true
	var skip = true;
	for(i = id_array.length-1; i > 0; i--) {
		if (f['id['+id_array[i]+']'].checked) {
			max_pos = i;
			if (skip) {
				// Skip the first one we come to because that is going to be 
				// the one the user just checked.
				skip = false;
				continue;
			} else {
				break;
			}
		}
	}
	 
	while (pos > max_pos+1) {
		pos = move_col_return('up');
	}
}
function move_col(direction)
{
	move_col_return(direction)
}
function move_col_return(direction)
{
	// make sure something has been selected
	if (!move_buttons) {
		alert('You must select a row to move');
		return;
	}
	var elemID = move_buttons.slice(1,move_buttons.length);
	var val = swap_elements(elemID, direction);
	return val;
}
function swap_elements(elemId, direction)
{
	reset_move_buttons();
	var f = document.view_form;
	var this_elem = document.getElementById('c'+elemId);
	
	// Get the positions
	elemPos = reverse_array[elemId];
	//alert(elemPos+': '+elemId);
	//alert(id_array[elemPos]);
	if ('down' == direction) {
		//if we're at the bottom, don't try to go down.
		if (id_array.length-1 == elemPos) {
			select_item(this_elem);
			return id_array.length-1;
		}
		// Get the next element
		nextElemId = id_array[Number(elemPos)+1];
		nextElemPos = Number(elemPos)+1;

		// Now update the positions
		reverse_array[elemId]++;
		reverse_array[nextElemId]--;
		f['position['+elemId+']'].value++;
		f['position['+nextElemId+']'].value--;
	} else {
		//if we're at the top, don't try to go up.
		if (1 == elemPos) {
			select_item(this_elem);
			return 1;
		}
		// Get the next element
		nextElemId = id_array[elemPos-1];
		nextElemPos = elemPos-1;

		// Now update the positions
		reverse_array[elemId]--;
		reverse_array[nextElemId]++;
		f['position['+elemId+']'].value--;
		f['position['+nextElemId+']'].value++;
	}			
	
	var next_elem = document.getElementById('c'+nextElemId);

	// Look to see what's checked (this information gets lost
	var e_sort = f['orderby['+elemId+']'].checked;
	var n_sort = f['orderby['+nextElemId+']'].checked;
	var e_sel = f['id['+elemId+']'].checked;
	var n_sel = f['id['+nextElemId+']'].checked;

	// Now swap the element
	var tmp = next_elem.innerHTML;
	next_elem.innerHTML = this_elem.innerHTML;
	this_elem.innerHTML = tmp;

	// Now update the id_array
	id_array[elemPos] = nextElemId;
	id_array[nextElemPos] = elemId;

	// Swap ids for divs
	this_elem.setAttribute('id','c'+nextElemId);
	next_elem.setAttribute('id','c'+elemId);

	// check the appropriate boxes again
	f['orderby['+elemId+']'].checked = e_sort;
	f['orderby['+nextElemId+']'].checked = n_sort;
	f['id['+elemId+']'].checked = e_sel;
	f['id['+nextElemId+']'].checked = n_sel;

	// Select moved item
	select_item(next_elem);

	return reverse_array[elemId];
}
function reset_move_buttons() 
{
	if (move_buttons != "") {
		document.getElementById(move_buttons).className='view_column'
		document.getElementById(move_buttons).style.textDecoration = 'none';
		move_buttons = "";
  }
}	


function select_item(i) 
{ 
	//alert(move_buttons);
	reset_move_buttons();
	i.className='hl_service';
	//i.style.textDecoration='underline';
	move_buttons = i.id;
}
function delete_view(id, name)
{
	if(confirm("Are you sure you would like to delete the " + name + " view?")) {
		document.views.view_id.value = id;
		document.views.submit();
	}
}