({
	submit : function(component, event, helper) {
        var RegForms=component.get("v.RegForm");
        
        var action=component.get("c.RegistrationForm");
        action.setParams({regFormObj: RegForms});

	},
    
    onchange: function(component, event, helper) {
        //done
              console.log("Hi controller");
    helper.onchange(component, event);
},
    addDetails:function(component, event, helper){
        console.log("Add details");
        var currentDetail=component.get("v.EducationList");
        var currentSize=parseInt(currentDetail.length);
        var newSize=parseInt((currentSize.length)+1);
                   currentDetail.push(newSize);                 
        component.set("v.EducationList",newSize);
    }
})