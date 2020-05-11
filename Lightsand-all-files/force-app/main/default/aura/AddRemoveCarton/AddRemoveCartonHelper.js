({
    getRecordValueshelper : function(component, event,helper) {
        var action = component.get("c.getcartonRecordData");
        var recordId = component.get("v.recordId");       
        action.setParams({ recId : recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                component.set("v.cartonDetails",stringItems);                
                var  status = component.get("v.cartonDetails.Status__c");
                var transfernote = component.get("v.cartonDetails.Transfer_Note__c");
                //|| $A.util.isEmpty(transfernote)
                if($A.util.isUndefinedOrNull(transfernote) && status === 'Active'){
                    component.set("v.showButtons", true);
                    component.set("v.showAddButton",true);
                    component.set("v.showRemoveButton",false);
                }   
                //(status === 'Empty Box in Transit' || status === 'Customer Warehouse')             
                if( !$A.util.isUndefinedOrNull(transfernote) && status === 'Active'){
                    component.set("v.showButtons", true);
                    component.set("v.showAddButton",false);
                    component.set("v.showRemoveButton",true);
                }
                /*if($A.util.isUndefinedOrNull(transfernote) && status !== 'Active'){
                    component.set("v.showButtons",false);
                } */
            }
        });
        $A.enqueueAction(action);
    },
    
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