({ 
    //Handler function load initial Values 
    doInit: function(cmp, event, helper) { 
        //helper.SourceTypeEvent(cmp, event, helper);
        
        var actions = helper.getRowActions.bind(this, cmp);
        
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        //Get selected the value 
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        //Saving the columns  

        cmp.set("v.isCurrentWeek", "true"); 
   
          cmp.set('v.demandColumns', [
            {label: 'Order To Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 300},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text',initialWidth: 100},
            {label: 'Model', fieldName: 'model', type: 'text',initialWidth: 90},
            {label: 'Color', fieldName: 'color', type: 'text',initialWidth: 75},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text',initialWidth: 20},
            {label: 'Total Demand', fieldName: 'totalDemandQty', type: 'number'},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number'},
            //{label: 'Total Shipment', fieldName: 'totalShipmentQty', type: 'number'},
            {label: 'Variance', fieldName: 'variance', type: 'number'},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number'},
            {label: 'Allocated But Not Received', fieldName: 'allocationNotReceived', type: 'number',initialWidth: 125},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);

      var  mainettiCompany;
      var  retailerCode;
      var  modelName;
      var  weekStartDate;
      var  weekEndDate;
      var  onlyShortFallRecords = false;
      var  isCurrentWeek = true;
        // call the helper function    
        helper.getDemandForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
         
    }, 
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'allocate':
                helper.allocateInventory(cmp, row, helper);
                break;     
        }
    },
    // this function call on click on the previous/Next page button   
    navigate: function(cmp, event, helper) { 
        
         var actions = helper.getRowActions.bind(this, cmp);
        
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        // get the button's label   
        var direction = event.getSource().get("v.label"); 
         
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
         
        // set the current page 
        page = direction === "Previous Page" ? (page - 1) : (page + 1); 
         
        cmp.set("v.isCurrentWeek", "true"); 
   
          cmp.set('v.demandColumns', [
            {label: 'Order To Company', fieldName: 'mainettiCompany', type: 'text'},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text'},
            {label: 'Model', fieldName: 'model', type: 'text'},
            {label: 'Color', fieldName: 'color', type: 'text'},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text'},
            {label: 'Total Demand', fieldName: 'totalDemandQty', type: 'number'},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number'},
            //{label: 'Total Shipment', fieldName: 'totalShipmentQty', type: 'number'},
            {label: 'Variance', fieldName: 'variance', type: 'number'},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number'},
            {label: 'Allocation received', fieldName: 'allocationReceived', type: 'text'},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
          
        /*cmp.set("v.mainettiCompany",event.getParam("company"));
        cmp.set("v.retailerCode",event.getParam("retailer"));
        cmp.set("v.modelName",event.getParam("product"));
        cmp.set("v.weekStartDate",event.getParam("startDate"));
        cmp.set("v.weekEndDate",event.getParam("endDate"));
        cmp.set("v.isCurrentWeek",event.getParam("currentWeek"));*/
        
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var modelName = cmp.get("v.modelName");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        //alert(isCurrentWeek);
        var onlyShortFallRecords = cmp.get("v.onlyShortFallRecords");
        
        // get the select option (drop-down) values.   
        //var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        //To do 
        //var page = cmp.get("v.page");
        
        // call the helper function    
        helper.getDemandForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
         
    }, 
     
    // this function call on the select opetion change, 
    onSelectChange: function(cmp, event, helper) { 
         var actions = helper.getRowActions.bind(this, cmp);
        var page = 1 
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        
         cmp.set("v.isCurrentWeek", "true"); 
   
          cmp.set('v.demandColumns', [
            {label: 'Order To Company', fieldName: 'mainettiCompany', type: 'text'},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text'},
            {label: 'Model', fieldName: 'model', type: 'text'},
            {label: 'Color', fieldName: 'color', type: 'text'},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text'},
            {label: 'Total Demand', fieldName: 'totalDemandQty', type: 'number'},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number'},
            //{label: 'Total Shipment', fieldName: 'totalShipmentQty', type: 'number'},
            {label: 'Variance', fieldName: 'variance', type: 'number'},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number'},
            {label: 'Allocation received', fieldName: 'allocationReceived', type: 'text'},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
          
        /*cmp.set("v.mainettiCompany",event.getParam("company"));
        cmp.set("v.retailerCode",event.getParam("retailer"));
        cmp.set("v.modelName",event.getParam("product"));
        cmp.set("v.weekStartDate",event.getParam("startDate"));
        cmp.set("v.weekEndDate",event.getParam("endDate"));
        cmp.set("v.isCurrentWeek",event.getParam("currentWeek"));*/
        
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var modelName = cmp.get("v.modelName");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        var onlyShortFallRecords = cmp.get("v.onlyShortFallRecords");
        
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        //To do 
        var page = cmp.get("v.page");
        // call the helper function 
        helper.getDemandForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
    }, 
    
    // this function is to handle the search when event is fired.  
    handleSearch: function(cmp, event, helper) {
        
        cmp.set("v.mainettiCompany",event.getParam("company"));
        cmp.set("v.retailerCode",event.getParam("retailer"));
        cmp.set("v.modelName",event.getParam("product"));
        cmp.set("v.weekStartDate",event.getParam("startDate"));
        cmp.set("v.weekEndDate",event.getParam("endDate"));
        cmp.set("v.isCurrentWeek",event.getParam("currentWeek"));
        cmp.set("v.onlyShortFallRecords",event.getParam("shortfallProducts"));
        
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var modelName = cmp.get("v.modelName");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        var onlyShortFallRecords = cmp.get("v.onlyShortFallRecords");
        
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        var page = cmp.get("v.page") || 1;
        
        // call the helper function    
        helper.getDemandForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
    },
    
    closeModal: function(component, event, helper) {
        
        component.set("v.sendsupplyId","");
        component.set("v.sendRetailer","");
        component.set("v.sendModel","");
        component.set("v.sendColor","");
        component.set("v.sendSizerPrint","");
        component.set("v.sendWarehouse","");
        component.set("v.isSourceToSource",false);
        component.set("v.OnAllocateClick",false);
        component.rerenderList();
        var modal = component.find("allocationModal");
        var modalBackdrop = component.find("allocationModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },    
     
})