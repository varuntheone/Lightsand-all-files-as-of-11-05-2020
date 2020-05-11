({    
    
    searchHelper : function(component,event,getInputkeyWord) {       
        // call the apex class method 
        var action = component.get("c.fetchLookupRetailerdataList"); 
        action.setParams({
            'enteredValue': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }     
        });
        $A.enqueueAction(action);        
    },
    
    
    searchProductHelper : function(component,event,getInputkeyWord) {       
        // call the apex class method 
        var action = component.get("c.fetchLookupProductdataList"); 
        action.setParams({
            'enteredValue': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message1", 'No Result Found...');
                } else {
                    component.set("v.Message1", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfProductSearchRecords", storeResponse);
            }
        });
        $A.enqueueAction(action);        
    },
    
    
    searchRtsHelper : function(component,event,getInputkeyWord) {        
        // call the apex class method 
        var action = component.get("c.fetchLookupRtsdataList"); 
        action.setParams({
            'enteredValue': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message2", 'No Result Found...');
                } else {
                    component.set("v.Message2", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfRtsSearchRecords", storeResponse);
            }            
        });
        $A.enqueueAction(action);        
    },
    
    
    searchMainettiHelper : function(component,event,getInputkeyWord) {        
        // call the apex class method 
        var action = component.get("c.fetchLookupMainettidataList"); 
        action.setParams({
            'enteredValue': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message3", 'No Result Found...');
                } else {
                    component.set("v.Message3", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfMainettiSearchRecords", storeResponse);
            }            
        });
        $A.enqueueAction(action);        
    },
    
    selectErrorToast: function(component,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Error",
                            message: text,
                            type: "error",
                            mode:"sticky"
                        });
                        toastEvent.fire();
    },
    
    getWarehousePicklist: function(component, event) {
        var action = component.get("c.getWarehouseMap");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var WarehousePicklistMap = [];
                for(var key in result){
                    WarehousePicklistMap.push({key: key, value: result[key]});
                }
                component.set("v.WarehousePicklistMap", WarehousePicklistMap);
            }
        });
        $A.enqueueAction(action);
    },
    
})