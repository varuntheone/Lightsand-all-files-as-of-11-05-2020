({ 
    getWeeklyForecast: function(cmp, mainettiCompany,retailerCode,model,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek) { 
        //alert("page:"+page);
        //alert("model:"+model);
        //alert("recordToDisplay:"+recordToDisplay);
        // create a server-side action.  
        var action = cmp.get("c.fetchWeeklyShipmentBySearch"); 
        // set the parameters to method  
        //alert("isCurrentWeek"+isCurrentWeek);
        action.setParams({ 
            "mainettiCompany": mainettiCompany, 
            "retailerCode": retailerCode, 
            "model": model,
            "weekStart": weekStartDate, 
            "weekEnd": weekEndDate,
            "onlyShortFallRecords": onlyShortFallRecords, 
            "pageNumber": page, 
            "recordToDisplay": recordToDisplay, 
            "isCurrentWeek": isCurrentWeek
        }); 
        //alert("pageNumber"+page);
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {    
                // store the response 
                var result = response.getReturnValue(); 
                // set the component attributes 
                cmp.set("v.WeeklyShipmentList", result.WeeklyShipmentListToDisplay); 
                //alert("WeeklyShipmentListToDisplay:"+result.WeeklyShipmentListToDisplay);
                cmp.set("v.page", result.pageNumber); 
                var total;
                if(result.totalWeeklyShipment != null){
                    var total = result.totalWeeklyShipment; 
                    //alert("total:"+total);
                    cmp.set("v.total", result.totalWeeklyShipment); 
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
    
    
})