({
    selectRecord : function(component, event, helper){      
    // get the selected record from list  
      var getSelectRecord = component.get("v.oProduct");
    // call the event   
      var compEvent = component.getEvent("osalesErrorMapByEvent");
    // set the Selected sObject Record to the event attribute.  
         compEvent.setParams({"salesErrorMapByEvent" : getSelectRecord });  
    // fire the event  
         compEvent.fire();
    },
})