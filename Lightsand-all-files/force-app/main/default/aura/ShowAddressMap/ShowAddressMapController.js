({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getcartonDetailsAddress");
        action.setParams({
            "recId" :recordId            
        });    
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {                
                var stringItems = response.getReturnValue();
                component.set('v.mapMarkersData', [
                    {
                        location: {
                            Street: response.getReturnValue().Street,
                            City: response.getReturnValue().City,
                            State: response.getReturnValue().State,
                            Country : response.getReturnValue().Country
                        },                    }
                ]);
                component.set('v.markersTitle', 'Carton location.');                                              
            }
        });     
        $A.enqueueAction(action);
    },
    
    refreshcontent : function(component, event, helper) {
        alert('refresh view');
    },
    
    doneRender : function(component, event, helper) {
        alert('doneRender');
    },
     showToast : function(component, event, helper) {
        alert('show showToast');
    },
    
})