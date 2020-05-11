({
    selectRtsRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRtsRecord = component.get("v.oRts");
        // call the event   
        var compRtsEvent = component.getEvent("oSearchEvent");
        // set the Selected sObject Record to the event attribute.  
        compRtsEvent.setParams({"recordRtsByEvent" : getSelectRtsRecord
                            });  
        // fire the event  
        compRtsEvent.fire();
    },
    
})