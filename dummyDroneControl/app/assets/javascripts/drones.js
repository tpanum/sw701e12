$(document).ready(function(){
	
	$(document).keydown(function(e){
	    
		switch(e.keyCode){
			case 32:
			alert("SPACE");
			case 37:
			alert( "left pressed" );
			break;
			case 38:
			alert( "up pressed" );
			break;
			case 39:
			alert( "right pressed" );
			break;
			case 40:
			alert( "down pressed" );
			break;
		}
		return false;
	});
});