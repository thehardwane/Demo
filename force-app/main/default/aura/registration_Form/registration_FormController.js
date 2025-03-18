({
	buttonclick : function(component, event, helper) {
        
        var x=component.get("v.submit")
        if(x==true)
        {
            alert("Vaue is true")
            component.set("v.submit","false")
        }
        else{
            alert("Vaue is false")
            component.set("v.submit","true")
        }
		
	}
})