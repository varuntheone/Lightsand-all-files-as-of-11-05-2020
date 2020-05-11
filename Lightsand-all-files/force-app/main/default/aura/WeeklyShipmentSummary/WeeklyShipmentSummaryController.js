({ 
    //Handler function load initial Values 
    doInit: function(cmp, event, helper) { 
       
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        //Get selected the value 
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        //Saving the columns  

        cmp.set("v.isCurrentWeek", "true"); 
   
          cmp.set('v.WeeklyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 300},
            {label: 'Mainetti Model', fieldName: 'model', type: 'text',initialWidth: 200},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text',initialWidth: 200},
            {label: 'Color', fieldName: 'color', type: 'text',initialWidth: 150},  
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text',initialWidth: 150},
            {label: 'Total Weekly Shipment', fieldName: 'totalShipmentQty', type: 'number'},
            
        ]);
          
      var  mainettiCompany;
      var  retailerCode;
      var  model;
      var  weekStartDate;
      var  weekEndDate;        
      var  onlyShortFallRecords;
      var  isCurrentWeek = true;
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,model,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
         
    }, 
    
    // this function call on click on the previous/Next page button   
    navigate: function(cmp, event, helper) { 
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        // get the button's label   
        var direction = event.getSource().get("v.label"); 
         
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
         
        // set the current page 
        var page = direction === "Previous Page" ? (page - 1) : (page + 1); 
         
        cmp.set("v.isCurrentWeek", "true"); 
   
          cmp.set('v.WeeklyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 300},
            {label: 'Mainetti Model', fieldName: 'model', type: 'text',initialWidth: 200},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text',initialWidth: 200},
            {label: 'Color', fieldName: 'color', type: 'text',initialWidth: 150},  
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text',initialWidth: 150},
            {label: 'Total Weekly Shipment', fieldName: 'totalShipmentQty', type: 'number'},
            
        ]);
          
      var  mainettiCompany= cmp.get("v.mainettiCompany");
      var  retailerCode= cmp.get("v.retailerCode");
      var  model= cmp.get("v.model");
      var weekStartDate = cmp.get("v.weekStartDate");
      var weekEndDate = cmp.get("v.weekEndDate");  
      var  onlyShortFallRecords= cmp.get("v.onlyShortFallRecords");
      var  isCurrentWeek = cmp.get("v.isCurrentWeek");
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,model,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
         
    }, 
     
    // this function call on the select opetion change,  
    onSelectChange: function(cmp, event, helper) { 
        var page = 1 
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        
         cmp.set("v.isCurrentWeek", "true"); 
   
          cmp.set('v.WeeklyColumns', [
            {label: 'Mainetti Company', fieldName: 'mainettiCompany', type: 'text',initialWidth: 300},
            {label: 'Mainetti Model', fieldName: 'model', type: 'text',initialWidth: 200},
            {label: 'Retailer Name', fieldName: 'retailerCode', type: 'text',initialWidth: 200},
            {label: 'Color', fieldName: 'color', type: 'text',initialWidth: 150},  
            {label: 'Sizer Printer', fieldName: 'sizerPrinter', type: 'text',initialWidth: 150},
            {label: 'Total Weekly Shipment', fieldName: 'totalShipmentQty', type: 'number'},
            
        ]);
          
      var  mainettiCompany= cmp.get("v.mainettiCompany");
      var  retailerCode= cmp.get("v.retailerCode");
      var  model= cmp.get("v.model");
      var weekStartDate = cmp.get("v.weekStartDate");
      var weekEndDate = cmp.get("v.weekEndDate");        
      var  onlyShortFallRecords= cmp.get("v.onlyShortFallRecords");
      var  isCurrentWeek = cmp.get("v.isCurrentWeek");
              
              
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,model,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
         
    },
    
     // this function is to handle the search when event is fired.  
    handleSearch: function(cmp, event, helper) {
        
        cmp.set("v.mainettiCompany",event.getParam("company"));
        cmp.set("v.retailerCode",event.getParam("retailer"));
        cmp.set("v.model",event.getParam("product"));
        cmp.set("v.weekStartDate",event.getParam("startDate"));
        cmp.set("v.weekEndDate",event.getParam("endDate"));
        cmp.set("v.isCurrentWeek",event.getParam("currentWeek"));
        cmp.set("v.onlyShortFallRecords",event.getParam("onlyShortFallRecords"));
        
       
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var model = cmp.get("v.model");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        var onlyShortFallRecords = cmp.get("v.onlyShortFallRecords");
        var page = cmp.get("v.page") || 1;      
        var recordToDisplay = cmp.find("recordSize").get("v.value");  
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,model,weekStartDate,weekEndDate,onlyShortFallRecords,page,recordToDisplay,isCurrentWeek); 
    }
     
})