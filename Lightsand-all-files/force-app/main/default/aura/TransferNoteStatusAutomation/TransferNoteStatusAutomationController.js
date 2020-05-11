({
	checkTransferNoteStatus : function(component, event, helper) {
		var recordId = component.get("v.recordId");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.transferNoteStatusAutomation");
        action.setParams({
            "recId" :recordId            
        });    
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue(); 
                component.set("v.transferNote", stringItems);
                //alert('----->'+JSON.stringify(response.getReturnValue().Total_Carton_Send__c))                               
            }
        });     
        $A.enqueueAction(action);
	}
})