let current_request = 0
let pressedKeys = {};

$(function() {
	window.onkeyup = function(e) { pressedKeys[e.keyCode] = false; };
	window.onkeydown = function(e) { pressedKeys[e.keyCode] = true; };

	window.addEventListener('message', function (event) {
		let item = event.data;

		if (item.show) {
			current_request = item.request;
			let _main_text = $("#main_text");

			_main_text.attr('maxlength', item.maxlength);
			_main_text.val("");	
			
			$("#title_").html(item.title);
			$(".main").fadeIn("swing");
			_main_text.focus();
		}

		if (item.hide) {
			$(".main").fadeOut("swing");
		}
	});

	$("#send").click(function() {
		let text = $("#main_text").val();

		$(".main").fadeOut( "swing" );

		$.post("https://mmkeyboard/response", JSON.stringify({
			request: current_request,
			value: text
		}));
	});

	$("textarea").focusin(function() {
		$.post("https://mmkeyboard/allowmove", JSON.stringify({
			allowmove: false
		}));
	});

	$("textarea").focusout(function() {
		$.post("https://mmkeyboard/allowmove", JSON.stringify({
			allowmove: true
		}));
	});

	jQuery(document).on("keydown", function (evt) {
		if (evt.keyCode == 27) { // pressed ESC to close without submiting
			$.post("https://mmkeyboard/response", JSON.stringify({
				request: current_request,
				value: ""
			}));
			$(".main").fadeOut("swing");
		}

		if(!pressedKeys[16] && evt.keyCode == 13) { // allows to use shift + enter
			document.getElementById('main_text').disabled=true;

			$(".main").fadeOut( "swing" );

			$.post("https://mmkeyboard/response", JSON.stringify({
				request: current_request,
				value: $("#main_text").val()
			}));

			document.getElementById('main_text').disabled=false;
		}
	});
});