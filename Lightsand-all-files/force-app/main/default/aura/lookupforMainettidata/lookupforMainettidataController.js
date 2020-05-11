({
    selectMainettiRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectMainettiRecord = component.get("v.oMainetti");
       
        // call the event   
        var compMainettiEvent = component.getEvent("oSearchEvent");
        // set the Selected sObject Record to the event attribute.  
        compMainettiEvent.setParams({"recordMainettiByEvent" : getSelectMainettiRecord
                            });  
        // fire the event  
        compMainettiEvent.fire();
    },
    
})