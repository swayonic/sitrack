jQuery(document).ready(function() {
	$(".search_item").each(function(){
		$(this).click(function(){
			id = $(this).attr('data');
			$("div.select_box").hide();
			$("div#"+id).show();
		});
	});
	$(".select_box").each(function(){
		$(this).mouseleave(function(){
			$(this).hide();
		});
	});
});