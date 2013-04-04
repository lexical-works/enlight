$(document).ready ->
	$('.orange').fadeTo 'fast', 0.9

	$('.orange').mouseenter ->
		$(this).fadeTo 'fast', 1.0

	$('.orange').mouseleave ->
		$(this).fadeTo 'fast', 0.9
	
	$('#alertbutton').click ->
		alert "Storm Earth And Fire Heed My Call !"