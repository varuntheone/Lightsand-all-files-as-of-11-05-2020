({
    getTransferNoteInformation : function(component, event, helper){
        var action = component.get("c.getTransferNoteData");
        action.setParams({
            "recId" :  component.get("v.recordId")
        });
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                //alert(JSON.stringify(result.getReturnValue()));
                component.set("v.transferNoteInfo",result.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },    
    
    getAllRecordsfromDB : function(component, event, helper){
        var action = component.get("c.getActiveCartonsNoTFNote");
        action.setParams({
            "transferNoteID" :  component.get("v.recordId")
        });
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                // console.log(JSON.stringify(result.getReturnValue()));
                component.set("v.cartonsList",result.getReturnValue());
                component.set("v.duplicateCartonsList",result.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    },      
    
    getCartonsofCurrentTransferNote : function(component, event, helper){
        var action = component.get("c.getActiveCartonswithTFNote");
        action.setParams({
            "transferNoteID" :  component.get("v.recordId")
        });
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                //alert(JSON.stringify(result.getReturnValue()));
                component.set("v.cartonswithTFNote",result.getReturnValue());   
            }
        });
        $A.enqueueAction(action);
    },  
    
    cartonTagingTransferNote : function(component, event, helper,selectedCartons) {
        if(!$A.util.isUndefinedOrNull(selectedCartons)){
            var action = component.get("c.updatecartonTransferNotefield");
            action.setParams({
                "transferNoteID" : component.get("v.recordId"),
                "cartonsIds" : selectedCartons
            });
            action.setCallback(this, function(result){
                var state = result.getState();
                if (component.isValid() && state === "SUCCESS"){
                    //alert(JSON.stringify(result.getReturnValue()));
                    //component.set("v.cartonsList",result.getReturnValue()); 
                    helper.getAllRecordsfromDB(component, event, helper);
                    helper.getCartonsofCurrentTransferNote(component, event, helper);
                    //var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    // dismissActionPanel.fire(); 
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    cartonRemovefromTransferNote : function(component, event, helper,selectedCartons) {
        if(!$A.util.isUndefinedOrNull(selectedCartons)){
            var action = component.get("c.updatecartonTransferNotefield");
            action.setParams({
                "transferNoteID" : null,
                "cartonsIds" : selectedCartons
            });
            action.setCallback(this, function(result){
                var state = result.getState();
                if (component.isValid() && state === "SUCCESS"){
                    //alert(JSON.stringify(result.getReturnValue()));
                    //component.set("v.cartonsList",result.getReturnValue()); 
                    helper.getAllRecordsfromDB(component, event, helper);
                    helper.getCartonsofCurrentTransferNote(component, event, helper);
                    component.set("v.isSelectAll",false);
                    component.set("v.isRemoveFromTFNote",false);
                    //var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    //dismissActionPanel.fire(); 
                }
            });
            $A.enqueueAction(action);
        }
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