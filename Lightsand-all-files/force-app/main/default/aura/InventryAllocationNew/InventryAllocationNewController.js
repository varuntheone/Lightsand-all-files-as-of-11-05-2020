({
    
    doInit: function(component, event, helper) {
        // Create the action
        var action = component.get("c.getOrdertoCompany");
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Ws", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action)
    },
    clickSave: function(component, event, helper) {
        //alert("hello");
        /* var qtyValue = component.find("Allocate_Qty").get("v.value");
        alert("qtyValue:"+qtyValue);*/
        var value = component.get("v.Allocate_Quantity");
        var action1 =component.get("c.save");
        //alert("hello");
        action1.setParams({ 
            "Qty": value	
        });
        //alert("Good");
        action1.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var status = a.getReturnValue();
                /*component.set("v.Quantity", Qty);*/
                alert("success");
            }
            else
            {
                alert("Failed");
            }
        });
        $A.enqueueAction(action1)
    }	
})