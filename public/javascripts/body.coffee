$(document).ready ->
	$('#addlinebutton').click ->
		$('#lastline').before '<li><strong>New Line Added :</strong> ' + new Date + '</li>'