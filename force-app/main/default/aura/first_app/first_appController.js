({
	openOrCloseForm : function(component, event, helper) {
        var a=event.getSource().get("v.label");
        if(a=="Open registration form")
        {
            component.set("v.RegForm",true);
            component.set("v.ButtonLabel","Close registration form");
        }
        if (a=="Close registration form"){
          
            component.set("v.RegForm",false);
            component.set("v.ButtonLabel","Open registration form");
        
        }
	}
})