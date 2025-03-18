({
	submit : function(component, event, helper) {
        var click=component.get("v.abc");
        if(click=="True")
        {
            alert("You have clicked on sumbit");
            component.set("v.abc","False");
        }
        else 
        {
            alert("False");
            component.set("v.abc","True");
        }
		
	}
})