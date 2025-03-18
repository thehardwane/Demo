({
	    invoke : function(component, event, helper) {


        var type = component.get("v.type").toLowerCase(); //force user entered attribute to all lowercase
        var title = component.get("v.title");
        var message = component.get("v.message");
        var duration = component.get("v.duration")+"000"; //convert duration value from seconds to milliseconds
        var mode = component.get("v.mode").toLowerCase(); //force user entered attribute to all lowercase
        var key = component.get("v.key").toLowerCase();   //force user entered attribute to all lowercase


        var isURL = message.toLowerCase().includes('{url}');  //Did the user include '{url}' in their message?


        if(!isURL){
            helper.showToast(type, title, message, duration, mode, key);
        }
        },
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("toast_flow");
    },
    handleStatusChange : function (component, event) {
		if(event.getParam("status") === "FINISHED") {
	// Get the output variables and iterate over them
	var outputVariables = event.getParam("outputVariables");
	
    }
    }
})