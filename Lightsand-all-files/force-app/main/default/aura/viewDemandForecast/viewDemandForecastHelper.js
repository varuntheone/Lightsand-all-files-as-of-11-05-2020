({ 
    getDemandForecast: function(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek) { 
        
        // create a server-side action.  
        var action = cmp.get("c.fetchDemandForecastBySearch"); 
        // set the parameters to method   
        action.setParams({ 
            "mainettiCompany": mainettiCompany, 
            "retailerCode": retailerCode, 
            "modelName": modelName,
            "weekStart": weekStartDate, 
            "weekEnd": weekEndDate, 
            "onlyShortFallRecords": onlyShortFallRecords, 
            "pageNumber": page, 
            "recordToDisplay": recordToDisplay, 
            "isCurrentWeek": isCurrentWeek
        }); 
       action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {    
                // store the response 
                var result = response.getReturnValue();                      
                // set the component attributes 
                cmp.set("v.DemandForecastList", result.DemandForecastListToDisplay); 
                cmp.set("v.page", result.pageNumber); 
                var total;
                if(result.totalDemandForecast != null){
                    var total = result.totalDemandForecast; 
                    cmp.set("v.total", result.totalDemandForecast); 
                }else{
                    var total = cmp.get("v.total"); 
                }
                var pagesReturned = (total/ recordToDisplay);
                if(pagesReturned == 0){
                    cmp.set("v.pages", 1);
                }else{
                     cmp.set("v.pages", Math.ceil(total/ recordToDisplay));
                }
                //cmp.set("v.pages", Math.ceil(total/ recordToDisplay)); 
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }             
        }); 
        
        // enqueue the action  
        $A.enqueueAction(action); 
    },
    getRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        if (row['totalBalance'] <= 0 && (row['weeklyDemandId'] != "" || row['weeklyDemandId'] != null) && row['hasAccessToAllocate'] == 'True' && row['totalSupplyQty'] > 0) {
            actions.push({
                'label': 'Allocation Inventory',
                'iconName': 'utility:add',
                'name': 'allocate'
            });
        }
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    allocateInventory:function (cmp, row, helper) {
        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:AllocateDemand",
            componentAttributes: {
                demandId : row.weeklyDemandId,
                sourceObj : 'Demand'
            }
        });
        evt.fire();*/
        
        cmp.set("v.sendDemandId",row.weeklyDemandId);
        cmp.set("v.isSourceToSource",false);
        cmp.set("v.OnAllocateClick",true);
        
        helper.openModal(cmp, event, helper);
    },
    
    /*SourceTypeEvent: function(cmp, event, helper){
       //cmp.set("v.source",event.getParam("DemandForecastList"));
        //var selSource = cmp.get("v.source");
        //alert("v.source");
        //alert("abc");
        var compEvent = cmp.getEvent("SourceDemand");  
        compEvent.setParams({"SourceType" : 'Demand'               
                            });    
        compEvent.fire();        
    },*/
    
    openModal: function(cmp, event, helper) {
        var modal = cmp.find("allocationModal");
        var modalBackdrop = cmp.find("allocationModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeModal: function(component, event, helper) {
        var modal = component.find("allocationModal");
        var modalBackdrop = component.find("allocationModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
})