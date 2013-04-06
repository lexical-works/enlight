$ ->
	$('#create_feed_form').submit ->
		$.ajax
			type: "POST",
			dataType: "html",
			url: "/feeds/new",
			data: $(this).serialize()
			success: (data) ->
				$('#feedlist').html data
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				alert XMLHttpRequest + "<br>" + textStatus + "<br>" + errorThrown
		false