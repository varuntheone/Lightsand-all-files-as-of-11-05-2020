({        
    // function to get the error details of Inventory_Transaction_Stage__c.    
    viewError : function(component, event, helper) {  
        //alert('inside detail view error');
        var params = event.getParam('arguments');
        component.set("v.flag",true);
        
        if (params) {
            var batchId = params.batchId;
            //alert('inside child batchId:'+batchId);
            // add your code here
            var actionError=component.get("c.getMaterialErrorData");
            actionError.setParams({
                batchid: batchId
            }); 
        }             
        
        actionError.setCallback(this,function (responseErr) {
            var state = responseErr.getState();
            if (state === "SUCCESS") {
                var res=responseErr.getReturnValue();
                //alert('status:'+res);
                component.set("v.errordata", res);
            } else if (state === "ERROR") {
                var errors = responseErr.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(actionError);        
    }
})