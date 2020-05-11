({
    
    getpicklistValues : function(component, event,helper) {
        var action = component.get("c.getPickListValues");
        var objectName = 'Carton_Details__c'; //component.get("v.sObjectName");  
        action.setParams({ objName :  objectName ,str:"Status__c"});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                //alert('------>'+JSON.stringify(stringItems));
                component.set("v.nwPicklist", stringItems); 
            }
        });
        $A.enqueueAction(action);
    } ,
    
    showToast : function(component, event,type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
})