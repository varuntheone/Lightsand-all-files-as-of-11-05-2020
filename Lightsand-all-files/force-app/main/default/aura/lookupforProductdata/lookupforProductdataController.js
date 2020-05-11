({
    selectProductRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectProductRecord = component.get("v.oProduct");
       
        // call the event   
        var compProductEvent = component.getEvent("oSearchEvent");
        // set the Selected sObject Record to the event attribute.  
        compProductEvent.setParams({"recordProductByEvent" : getSelectProductRecord
                            });  
        // fire the event  
        compProductEvent.fire();
    },
    
})