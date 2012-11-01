$(document).ready(function(){
	var t = $('.notice')
	t.css({top: 42-t.height()+"px"});
	t.animate({top: parseInt(t.css("top"))+t.height()+"px"}, 500, function(){
		t.delay(5000).animate({top: 42-t.height()+"px"}, 500, function(){
			t.remove();
		});
	});
});