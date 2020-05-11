({ 
    getWeeklyForecast: function(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,pageNumber,recordToDisplay,isCurrentWeek,allocationType) { 
        //alert("page:"+page);
        //alert('isCurrentWeek:'+allocationType);
        // create a server-side action.  
        var action = cmp.get("c.fetchWeeklyAllocationBySearch"); 
        // set the parameters to method  
        
        action.setParams({ 
            "mainettiCompany":mainettiCompany,
            "retailerCode":retailerCode,
            "modelName":modelName,
            "weekStart":weekStartDate,
            "weekEnd":weekEndDate,
            // "onlyShortFallRecords": onlyShortFallRecords, 
            "pageNumber": pageNumber,
            "recordToDisplay": recordToDisplay,
            "isCurrentWeek":isCurrentWeek,
            //"allocateddate":allocateddate,
            "allocationType":allocationType
            
        }); 
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {    
                // store the response 
                var result = response.getReturnValue(); 
                //alert("result:"+result.WeeklyAllocationSummaryListToDisplay);
                //console.log ('**********result ' + JSON.stringify(result));                     
                // set the component attributes 
                // alert('WeeklyAllocationSummaryListToDisplay:'+result.WeeklyAllocationSummaryListToDisplay);
                cmp.set("v.WeeklyAllocationSummaryList", result.WeeklyAllocationSummaryList); 
                
                cmp.set("v.page", result.pageNumber); 
                var total;
                if(result.totalWeeklyAllocation != null){
                    var total = result.totalWeeklyAllocation; 
                    //alert("total:"+total);
                    cmp.set("v.total", result.totalWeeklyAllocation); 
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
    getWeeklyRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        if (row['isCurrentWeek__c'] == true){
            actions.push({
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'delete',
                
            });
        }
        
        // simulate a trip to the server
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    
    deleteSelectedRecord: function (cmp, row, doneCallback) {
        //alert("insideDelete"+row.Id);
        var selId = row.Id;
        var action = cmp.get("c.DeleteRecords");        
        action.setParams({
            'selId':selId  
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result == true){
                    alert('record is deleted');
                    cmp.rerenderList();
                }
                else{
                    alert('record not deleted');
                }
            }
        });
        $A.enqueueAction(action); 
    },
    successToast: function(cmp,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            message: text,
            type: "success",
            mode:"pester"
        });
        
        toastEvent.fire();
    },
    selectErrorToast: function(cmp,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error",
            message: text,
            type: "error",
            mode:"sticky"
        });
        toastEvent.fire();
    },
    DeleteToast: function(cmp,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            message: text,
            type: "success",
            mode:"pester"
        });
        toastEvent.fire();
    },
    DeleteErrorToast: function(cmp,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error",
            message: text,
            type: "error",
            mode:"sticky"
        });
        toastEvent.fire();
    },
    
})