# test if script can be included inside <body></body> tags

$ ->
	$('#addlinebutton').click ->
		$('#lastline').before '<li><strong>New Line Added :</strong> ' + new Date + '</li>'

	$('#linkbutton').click ->
		$(this).attr 'disabled', 'disabled'
		$(this).ajaxStop ->
			$(this).removeAttr 'disabled'

		$.ajax
			type: "GET",
			dataType: "html",
			url: "/feeds/list",
			success: (data) ->
				$('#feedlist').html data
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				alert XMLHttpRequest + "<br>" + textStatus + "<br>" + errorThrown
