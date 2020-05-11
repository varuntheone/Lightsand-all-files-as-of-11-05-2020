({ 
    //Handler function load initial Values 
    doInit: function(cmp, event, helper) { 
        var actions = helper.getRowActions.bind(this, cmp);
        
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        //Get selected the value 
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        //Saving the columns  

        cmp.set("v.isCurrentWeek", "true"); 
   
        cmp.set('v.supplyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 270},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text',initialWidth: 100},
            {label: 'Model', fieldName: 'model', type: 'text',initialWidth: 100},
            {label: 'Color', fieldName: 'color', type: 'text',initialWidth: 100},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text',initialWidth: 100},
            {label: 'Source', fieldName: 'source', type: 'text',initialWidth: 100},
            {label: 'Warehouse', fieldName: 'warehouse', type: 'text',initialWidth: 100},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number',initialWidth: 100},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number',initialWidth: 100},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
           /*
           
    public Double ;
    public Double ;
    public Double ;
    public Double ;
    public Boolean isNegative;
    public Double ;
    public ID weeklyDemandId;
    public ID weeklySupplyId;
    public ID weeklyShipmentId;           
           
           
           */
      var  mainettiCompany;
      var  retailerCode;
      var  modelName;
      var  weekStartDate;
      var  weekEndDate;
      var  onlyShortFallRecords;
      var  isCurrentWeek = true;
      var  source = cmp.get("v.source");
      var  warehouse = cmp.get("v.wareHouse");
        // call the helper function    
        helper.getSupplySummary(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek,page,recordToDisplay,source,warehouse); 
         
    }, 
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'allocate':
                //alert("row:"+row.Id);
                helper.allocateInventory(cmp, row, helper)
                break;     
            case 'supply':
                //alert("row:"+row.Id);
                helper.allocateSupplyToSupply(cmp, row, helper)
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
   
          /*cmp.set('v.supplyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 250},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text'},
            {label: 'Model', fieldName: 'model', type: 'text'},
            {label: 'Color', fieldName: 'color', type: 'text'},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text'},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number'},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number'},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
           { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);*/
        
        cmp.set('v.supplyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 270},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text',initialWidth: 100},
            {label: 'Model', fieldName: 'model', type: 'text',initialWidth: 100},
            {label: 'Color', fieldName: 'color', type: 'text',initialWidth: 100},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text',initialWidth: 100},
            {label: 'Source', fieldName: 'source', type: 'text',initialWidth: 100},
            {label: 'Warehouse', fieldName: 'warehouse', type: 'text',initialWidth: 100},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number',initialWidth: 100},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number',initialWidth: 100},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
          
      /*var  mainettiCompany;
      var  retailerCode;
      var  modelName;
      var  weekStartDate;
      var  weekEndDate;
      var  onlyShortFallRecords;
      var  isCurrentWeek = true;*/
        
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var modelName = cmp.get("v.modelName");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        var onlyShortFallRecords = cmp.get("v.shortfallProducts");
        var  source = cmp.get("v.source");
        var  warehouse = cmp.get("v.wareHouse");
        // call the helper function 
        helper.getSupplySummary(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek,page,recordToDisplay,source,warehouse);
    }, 
     
    // this function call on the select opetion change,  
    onSelectChange: function(cmp, event, helper) { 
         var actions = helper.getRowActions.bind(this, cmp);
        var page = 1 
        // get the select option (drop-down) values.   
        //var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        
         cmp.set("v.isCurrentWeek", "true"); 
   
          /*cmp.set('v.supplyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 250},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text'},
            {label: 'Model', fieldName: 'model', type: 'text'},
            {label: 'Color', fieldName: 'color', type: 'text'},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text'},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number'},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number'},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
           { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);*/
        
        cmp.set('v.supplyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 270},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text',initialWidth: 100},
            {label: 'Model', fieldName: 'model', type: 'text',initialWidth: 100},
            {label: 'Color', fieldName: 'color', type: 'text',initialWidth: 100},
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text',initialWidth: 100},
            {label: 'Source', fieldName: 'source', type: 'text',initialWidth: 100},
            {label: 'Warehouse', fieldName: 'warehouse', type: 'text',initialWidth: 100},
            {label: 'Total Supply', fieldName: 'totalSupplyQty', type: 'number',initialWidth: 100},
            {label: 'Total Allocation', fieldName: 'totalAllocationQty', type: 'number',initialWidth: 100},
            {label: 'Balance', fieldName: 'totalBalance', type: 'number',cellAttributes: { class: { fieldName: 'isNegative' }}},
            { type: 'action', typeAttributes: { rowActions: actions } }
            
        ]);
          
      /*var  mainettiCompany;
      var  retailerCode;
      var  modelName;
      var  weekStartDate;
      var  weekEndDate;
      var  onlyShortFallRecords;
      var  isCurrentWeek = true;*/
        
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var modelName = cmp.get("v.modelName");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        var onlyShortFallRecords = cmp.get("v.shortfallProducts");
        var source = cmp.get("v.source");
      	var warehouse = cmp.get("v.wareHouse");
        
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value");
        //alert(recordToDisplay);
        //To do 
        var page = cmp.get("v.page");
        
        // call the helper function
        helper.getSupplySummary(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek,page,recordToDisplay,source,warehouse);
    },
    
    // this function is to handle the search when event is fired.  
    handleSearch: function(cmp, event, helper) {
        /*
         * var selMainettiCompany = event.getParam("company");
        var selRetailerCode = event.getParam("retailer");
        var selModelName = event.getParam("product");
        var selWeekStartDate = event.getParam("startDate");
        var selWeekEndDate = event.getParam("endDate");
        //var selSource = event.getParam("source");
        var selIsCurrentWeek = event.getParam("currentWeek");
        //var selOnlyShortFallRecords = event.getParam("shortfallProducts");
        */
        
        cmp.set("v.mainettiCompany",event.getParam("company"));
        cmp.set("v.retailerCode",event.getParam("retailer"));
        cmp.set("v.modelName",event.getParam("product"));
        cmp.set("v.weekStartDate",event.getParam("startDate"));
        cmp.set("v.weekEndDate",event.getParam("endDate"));
        cmp.set("v.isCurrentWeek",event.getParam("currentWeek"));
        cmp.set("v.source",event.getParam("source"));
        cmp.set("v.wareHouse",event.getParam("warehouse"));
        
        
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var modelName = cmp.get("v.modelName");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        var source = cmp.get("v.source");
        var wareHouse = cmp.get("v.wareHouse");
        
        //alert(wareHouse);
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        var page = cmp.get("v.page") || 1;
        
        // call the helper function    
        helper.getSupplySummary(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek,page,recordToDisplay,source,wareHouse); 
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