({
	doAdd : function(component, event, helper) {
        var input1= component.get('v.FirstValue');
        
        var input2= component.get('v.SecondValue');
        
		component.set('v.Output',parseInt(input1) + parseInt(input2));
    },
    	doSub : function(component, event, helper) {
        var input1= component.get('v.FirstValue');
        
        var input2= component.get('v.SecondValue');
        alert(parseInt(input1) - parseInt(input2));
		
    },
    	doDiv : function(component, event, helper) {
        var input1= component.get('v.FirstValue');
        
        var input2= component.get('v.SecondValue');
        alert(parseInt(input1) / parseInt(input2));
		
    }
	
})