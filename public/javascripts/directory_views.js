function delete_view(id, name)
{
	if(confirm("Are you sure you would like to delete the " + name + " view?")) {
		document.location = '/views/delete?id=' + id;
	}
}