var takeoff = false;

$(document).ready(function(){
	
	$(document).keydown(function(e){
	    var action;
	
		switch(e.keyCode){
			case 32:
			if(takeoff){
				action = "landing"
				takeoff = false;
			} else {
				action = "takeoff"
				takeoff = true;
			}
			break;
			case 37:
				action = "left"
			break;
			case 38:
				action = "forward"
			break;
			case 39:
				action = "right"
			break;
			case 40:
				action = "backward"
			break;
			case 72:
				action = "hover"
			break;
		}
		
		$.post('/drones/'+action);
		
		return false;
	});
	
	$(document).keyup(function(e){
		
		$.post('/drones/hover');
		
		return false;
	});
});