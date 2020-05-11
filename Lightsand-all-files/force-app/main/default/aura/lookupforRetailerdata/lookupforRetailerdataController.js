({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRetailer");
        // call the event   
        var compRetailerEvent = component.getEvent("oSearchEvent");
        // set the Selected sObject Record to the event attribute.  
        compRetailerEvent.setParams({"recordRetailerByEvent" : getSelectRecord
                            });  
        // fire the event  
        compRetailerEvent.fire();
    },
    
})