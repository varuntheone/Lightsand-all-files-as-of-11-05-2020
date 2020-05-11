({
	callMe : function(component, event, helper) {
      
            var action=component.get("c.Inventory_Allocation_Records");
            action.setCallback(this,function(response){
            var state=response.getState();
            if(state==='SUCCESS'){
            var result=response.getReturnValue();
            component.set("v.lis",result);
            }
        });
        $A.enqueueAction(action);
	}
})