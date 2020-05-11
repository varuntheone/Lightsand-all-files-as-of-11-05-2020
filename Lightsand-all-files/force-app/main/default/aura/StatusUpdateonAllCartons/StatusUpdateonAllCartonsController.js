({
    doInit : function(component, event,helper){
        
        var recordId = component.get("v.recordId");
        var action = component.get("c.getTransferNoteData");
        action.setParams({
            "recId" :recordId            
        });    
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue(); 
                component.set("v.transferNote", stringItems);
                //alert('----->'+JSON.stringify(response.getReturnValue().Total_Carton_Send__c))
                if(response.getReturnValue().Total_Carton_Send__c > 0){
                    component.set("v.status", 'Yes'); 
                    helper.getpicklistValues(component, event,helper);
                }else{
                    component.set("v.status", 'No');
                }                
            }
        });     
        $A.enqueueAction(action);
       
    },
    
    updaterecordpicklist :function(component, event, helper) {        
        var lov = component.find("picklistId").get("v.value");
        var objrecordId = component.get("v.recordId");
        //alert('--lov---->'+lov+'----->'+objrecordId);
        if(!$A.util.isEmpty(lov) && !$A.util.isUndefined(lov) && lov != '--None--') {
            var action = component.get("c.updateAllCartonStatus");
            action.setParams({ recId: objrecordId, lov : lov });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var message = response.getReturnValue();
                    helper.showToast(component, event,'success','Success!',message);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire(); 
                    //alert('----->'+JSON.stringify(stringItems)); 
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    
    closePopUp:function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire();    
         $A.get('e.force:refreshView').fire();
    },
 
})