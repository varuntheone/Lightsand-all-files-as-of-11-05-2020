({ 
    getSupplySummary: function(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek,page,recordToDisplay,source,wareHouse) { 
        /*
        alert("selCompany:"+mainettiCompany+"\n"+
              "selRetailer:"+retailerCode+"\n"+
              "selProduct:"+modelName+"\n"+
              "selStartDate:"+weekStartDate+"\n"+
              "selEndDate:"+weekEndDate+"\n"+
              "selSource:"+source+"\n"+
              "isCurrentWeekChecked:"+isCurrentWeek+"\n"+
              "warehouse:"+wareHouse
             );
         */
             
        // create a server-side action.  
        var action = cmp.get("c.fetchSupplySummaryBySearch"); 
        action.setParams({ 
            "orderToCompany": mainettiCompany, 
            "retailerCode": retailerCode, 
            "modelName": modelName,
            "weekStart": weekStartDate, 
            "weekEnd": weekEndDate, 
            //"onlyShortFallRecords": onlyShortFallRecords, 
            "isCurrentWeek": isCurrentWeek,
            "pageNumber": page, 
            "recordToDisplay": recordToDisplay,
            "source": source,
            "warehouse": wareHouse
        });
        action.setCallback(this, function(response) {  
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                cmp.set("v.SupplySummaryList", result.DemandForecastListToDisplay);
                //alert(result.DemandForecastListToDisplay);
                
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
        //alert(row['hasAccessToAllocate']);
        var actions = [];
        if (row['totalBalance'] >= 0 && row['weeklySupplyId'] != "" && row['hasAccessToAllocate'] == 'True' && row['source'] == 'Reuse') {
            actions.push({
                'label': 'Allocation Demand',
                'iconName': 'utility:add',
                'name': 'allocate'
            });
        }
        //Allocatate supply
        if (row['totalBalance'] >= 0 && row['weeklySupplyId'] != "" && row['hasAccessToAllocate'] == 'True' && row['source'] == 'Virgin') {
            actions.push({
                'label': 'Allocation Supply',
                'iconName': 'utility:add',
                'name': 'supply'
            });
        }
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    allocateInventory:function (cmp, row, helper) {
        //alert('retailerCode:'+row.retailerCode);
        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:AllocateDemand",
            componentAttributes: {
                supplyId : row.weeklySupplyId,
                //retailer : row.retailerCode,
                sourceObj : 'Supply'            
            }
        });
        evt.fire();*/
        
        cmp.set("v.sendSupplyId",row.weeklySupplyId);
        cmp.set("v.isSourceToSource",false);
        cmp.set("v.OnAllocateClick",true);
        
        helper.openModal(cmp, event, helper);
    },
    
    allocateSupplyToSupply:function (cmp, row, helper) {
        //alert('retailerCode:'+row.retailerCode);
        /*var modalEvent = cmp.getEvent("modalCommunication");
        modalEvent.setParams({ "supplyId": row.weeklySupplyId,
                              "retailer": row.retailerCode,
                              "model": row.model,
                              "color": row.color,
                              "sizerPrint": row.sizerPrinter,
                              "warehouse": row.warehouse
                             	});
        modalEvent.fire();*/
        
        cmp.set("v.sendSupplyId",row.weeklySupplyId);
        cmp.set("v.sendRetailer",row.retailerCode);
        cmp.set("v.sendModel",row.model);
        cmp.set("v.sendColor",row.color);
        cmp.set("v.sendSizerPrint",row.sizerPrinter);
        cmp.set("v.sendWarehouse",row.warehouse);
        cmp.set("v.isSourceToSource",true);
        cmp.set("v.OnAllocateClick",true);
        
        helper.openModal(cmp, event, helper);
        
        /*
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:AllocateDemand",
            componentAttributes: {
                supplyId : row.weeklySupplyId,
                retailer : row.retailerCode,
                model : row.model,
                color : row.color,
                sizerPrint: row.sizerPrinter,
                warehouse: row.warehouse,
                isSourceToSource : true,
                sourceObj : 'Supply'            
            }
        });
        evt.fire();
        */
    },
    
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