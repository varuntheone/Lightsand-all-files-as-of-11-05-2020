({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRetailer");
        //alert("Retailer:"+getSelectRecord.Name);
        //var getSelectUserRecord = component.get("v.oUser");
        
        // call the event   
        var compEvent = component.getEvent("oRetailerdataEvent");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"recordByEvent" : getSelectRecord
                            });  
        // fire the event  
        compEvent.fire();
    },
    
})