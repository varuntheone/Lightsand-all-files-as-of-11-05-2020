({
    getRecordValues : function(component, event,helper) {
        helper.getRecordValueshelper(component, event,helper);
    },
    
    AddtoContainer : function(component, event,helper) {
        var action = component.get("c.addCartonfromTransferNote");
        var recordId = component.get("v.recordId");
        action.setParams({ cartonId : recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                if(stringItems === 'SUCCESS'){
                    helper.getRecordValueshelper(component, event,helper);
                    helper.showToast(component, event,'success','Success!','Carton Added to Transfer Note.');
                    $A.get('e.force:refreshView').fire();
                }else{
                    helper.showToast(component, event,'Error','Error!','Please update Transfer Note status/Goods Loded By Fields.'); 
                }  
            }
        });
        $A.enqueueAction(action);
    },
    
    RemoveContainer : function(component, event,helper) {
        var action = component.get("c.removeCartonFromTransferNote");
        var recordId = component.get("v.recordId");
        action.setParams({ cartonId : recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();                
                if(stringItems === 'SUCCESS'){
                    helper.getRecordValueshelper(component, event,helper);
                    helper.showToast(component, event,'success','Success!','Carton removed from Transfer Note.');
                    $A.get('e.force:refreshView').fire();
                }else{
                    helper.showToast(component, event,'Error','Error!','Please update Transfer Note status/Goods Loded By Fields.'); 
                }  
            }
        });
        $A.enqueueAction(action);
    },
    
    
})