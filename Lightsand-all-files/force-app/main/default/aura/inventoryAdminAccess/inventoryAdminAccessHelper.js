({
	initializeRetailerData : function(component,event,helper,batchId) {
        //alert("batchId:"+batchId);
        var action=component.get("c.getRetailerData");
        action.setParams({
            "batchid": batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.retailerData", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    initializeModelData : function(component,event,helper,batchId) {
        //alert("batchId:"+batchId);
        var action=component.get("c.getModelData");
        action.setParams({
            "batchid": batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.modelData", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    processUploadingOfData: function(component,event,helper,batchId) {
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:batchMaster"
        });
        evt.fire();
       
        var action = component.get("c.recStatusUpsertForInventory"); 
        action.setParams({
            "batchid" : batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    helper.updateInvSuccessCheckbox(component,event,helper,batchId);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                //helper.openErrorModal(component,helper); 
            }
        });
        $A.enqueueAction(action);      
    },
    updateInvSuccessCheckbox: function(component,event,helper,batchId) {
        var action = component.get("c.recUpdateFOrInvSuccess"); 
        action.setParams({
            "batchid" : batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    helper.uploadAzureWindowForFileUpload(component,helper,batchId);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                //helper.openErrorModal(component,helper); 
            }
        });
        $A.enqueueAction(action); 
    },
    uploadAzureWindowForFileUpload: function(component,helper,batchId) {
        //alert("batchId:"+batchId);
        var w = 460;
        var h = 250;
        var left = Number((screen.width/2)-(w/2));
        var tops = Number((screen.height/2)-(h/2));
        var winObjct = window.open('/apex/azureInventoryFileUpload?Id=' + batchId,'Inventory Data Upload','width=' + (parseInt(window.innerWidth) * 0.4) + ',height=' + (parseInt(window.innerHeight) * .6) + ',toolbar=0,menubar=0,location=0,status=0,scrollbars=0,resizable=0,left='+left+',top='+tops);
    },
    // Update related checkboxes on click of Notify User.
    updateInvFailureCheckbox: function(component,event,helper,batchId) {
        var action = component.get("c.recUpdateFOrInvFailure"); 
        action.setParams({
            "batchid" : batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    var text = 'Email notification to user has been sent for re-upload';
                    helper.successToast(component,event,helper,text);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                //helper.openErrorModal(component,helper); 
            }
        });
        $A.enqueueAction(action); 
    },
    selectNormalToast: function(component,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            //title: "Error",
                            message: text,
                            //type: "error",
                            mode:"sticky"
                        });
                        toastEvent.fire();
    },
    successToast: function(component,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Success!",
                            message: text,
                            type: "success",
                            mode:"pester"
                        });
                        toastEvent.fire();
    },
})