({ 
    //Handler function load initial Values 
    doInit: function(cmp, event, helper) { 
        
        var actions = helper.getWeeklyRowActions.bind(this, cmp);
        
        //Check if the page is select or not, Default 1 
        var pageNumber = cmp.get("v.pageNumber") || 1; 
        //Get selected the value 
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        //Saving the columns  
        
        cmp.set("v.isCurrentWeek", "true"); 
        
        cmp.set('v.WeeklyColumns', [
            {label: 'Order To Company', fieldName: 'Order_to_Company__c', type: 'text',initialWidth: 300},
            {label: 'Retailer Name', fieldName: 'Retailer_Name__c', type: 'text',initialWidth: 150},
            {label: 'Mainetti Model', fieldName: 'Mainetti_Model_Name__c', type: 'text',initialWidth: 150},
            {label: 'Color', fieldName: 'Color__c', type: 'text',initialWidth: 100},
            {label: 'Sizer Printer', fieldName: 'Sizer_Print__c', type: 'text',initialWidth: 150},
            {label: 'Inventory Allocation Type', fieldName: 'Inventory_Allocation_Type__c', type: 'text'},
            {label: 'Quantity', fieldName:'Quantity__c', type: 'number',initialWidth: 100, editable: true},
            {label: 'AllocatedDate', fieldName:'AllocatedDateText__c', type: 'Date',initialWidth: 100},
            { type: 'action', typeAttributes: { rowActions: actions } }          
        ]);
        
        var  mainettiCompany;
        var  retailerCode;
        var  modelName;
        var  weekStartDate;
        var  weekEndDate;
        var  onlyShortFallRecords;
        var pageNumber;
        var  isCurrentWeek = true;
        //var source=cmp.get("v.source");
        //var allocationType = 'Supply';
        var allocationType = cmp.get("v.allocationType");
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,pageNumber,recordToDisplay,isCurrentWeek,allocationType); 
    }, 
    
    handleWeeklyRowAction: function (cmp, event, helper) {
        var actions = helper.getWeeklyRowActions.bind(this, cmp);
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                helper.deleteSelectedRecord(cmp, row);
                break; 
                
        }
    },
    
    // this function call on click on the previous/Next page button   
    navigate: function(cmp, event, helper) { 
        
        var actions = helper.getWeeklyRowActions.bind(this, cmp);       
        
        //Check if the page is select or not, Default 1 
        var page = cmp.get("v.page") || 1; 
        // get the button's label   
        var direction = event.getSource().get("v.label"); 
        
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        // set the current page 
        var pageNumber = direction === "Previous Page" ? (page - 1) : (page + 1); 
        
        cmp.set("v.isCurrentWeek", "true"); 
        
        cmp.set('v.WeeklyColumns', [
            {label: 'Order To Company', fieldName: 'Order_to_Company__c', type: 'text',initialWidth: 300},
            {label: 'Retailer Name', fieldName: 'Retailer_Name__c', type: 'text',initialWidth: 150},
            {label: 'Mainetti Model', fieldName: 'Mainetti_Model_Name__c', type: 'text',initialWidth: 150},
            {label: 'Color', fieldName: 'Color__c', type: 'text',initialWidth: 100},
            {label: 'Sizer Printer', fieldName: 'Sizer_Print__c', type: 'text',initialWidth: 150},
            {label: 'Inventory Allocation Type', fieldName: 'Inventory_Allocation_Type__c', type: 'text'},
            {label: 'Quantity', fieldName:'Quantity__c', type: 'number',initialWidth: 100, editable: true},
            {label: 'AllocatedDate', fieldName:'AllocatedDateText__c', type: 'Date',initialWidth: 100},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var  mainettiCompany;
        var  retailerCode;
        var  modelName;
        var  weekStartDate;
        var  weekEndDate;
        var pageNumber;
        var  onlyShortFallRecords;
        var  isCurrentWeek = true;
        var allocationType = cmp.get("v.allocationType");
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,pageNumber,recordToDisplay,isCurrentWeek,allocationType); 
        
    }, 
    
    // this function call on the select opetion change,  
    onSelectChange: function(cmp, event, helper) { 
        var actions = helper.getWeeklyRowActions.bind(this, cmp);
        var page = 1 
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        //alert("alert 1");
        
        cmp.set("v.isCurrentWeek", "true"); 
        
        cmp.set('v.WeeklyColumns', [
            
            {label: 'Order To Company', fieldName: 'Order_to_Company__c', type: 'text',initialWidth: 300},
            {label: 'Retailer Name', fieldName: 'Retailer_Name__c', type: 'text',initialWidth: 150},
            {label: 'Mainetti Model', fieldName: 'Mainetti_Model_Name__c', type: 'text',initialWidth: 150},
            {label: 'Color', fieldName: 'Color__c', type: 'text',initialWidth: 100},
            {label: 'Sizer Printer', fieldName: 'Sizer_Print__c', type: 'text',initialWidth: 150},
            {label: 'Inventory Allocation Type', fieldName: 'Inventory_Allocation_Type__c', type: 'text'},
            {label: 'Quantity', fieldName:'Quantity__c', type: 'number',initialWidth: 100, editable: true},
            {label: 'AllocatedDate', fieldName:'AllocatedDateText__c', type: 'Date',initialWidth: 100},
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var mainettiCompany;
        var  retailerCode;
        var modelName;
        var  weekStartDate;
        var  weekEndDate;
        var pageNumber;
        var  onlyShortFallRecords;
        var  isCurrentWeek = true;
        var allocationType = cmp.get("v.allocationType");
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,pageNumber,recordToDisplay,isCurrentWeek,allocationType); 
        
    },
    
    // this function is to handle the search when event is fired.  
    handleSearch: function(cmp, event, helper) {
        
        
        cmp.set("v.mainettiCompany",event.getParam("company"));
        cmp.set("v.retailerCode",event.getParam("retailer"));
        cmp.set("v.modelName",event.getParam("product"));
        cmp.set("v.weekStartDate",event.getParam("startDate"));
        cmp.set("v.weekEndDate",event.getParam("endDate"));
        //cmp.set("v.allocation",event.getparam("allocation"));
        cmp.set("v.isCurrentWeek",event.getParam("currentWeek"));
        //cmp.set("v.pageNumber",event.getParam("pageNumber"));
        //cmp.set("v.recordToDisplay",event.getParam("recordToDisplay"));
        cmp.set("v.allocateddate",event.getParam("allocateddate"))
        cmp.set("v.allocationType",event.getParam("allocationType"));
        cmp.set("v.onlyShortFallRecords",event.getParam("onlyShortFallRecords"));
        //cmp.set("v.draftValues",event.getParam("draftValues"));
        
        var mainettiCompany = cmp.get("v.mainettiCompany");
        var retailerCode = cmp.get("v.retailerCode");
        var modelName = cmp.get("v.modelName");
        var weekStartDate = cmp.get("v.weekStartDate");
        var weekEndDate = cmp.get("v.weekEndDate");
        var isCurrentWeek = cmp.get("v.isCurrentWeek");
        var onlyShortFallRecords = cmp.get("v.onlyShortFallRecords");
        //var pageNumber = cmp.get("v.pageNumber");
        //var recordToDisplay = cmp.get("v.recordToDisplay");
        var allocateddate = cmp.get("v.allocateddate");
        var allocationType = cmp.get("v.allocationType");
        
        
        // get the select option (drop-down) values.   
        var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        
        var pageNumber = cmp.get("v.page") || 1;
        
        // call the helper function    
        helper.getWeeklyForecast(cmp, mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,pageNumber,recordToDisplay,isCurrentWeek,allocationType); 
    },
    
    /*deleteRecord:function(cmp, event, helper){
        helper.deleteSelectedRecord(cmp, event, helper); 
    },*/
    
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        
        //console.log('updatedRecords:'+draftValues);
        //alert('draftValues:'+draftValues.Id);
        var action = cmp.get("c.updateAlocation");
        action.setParams({"allocRecord" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //alert(result)
                if(result == true){                    
                    var text = 'Record is updated succesfully';
                    helper.successToast(cmp,event,helper,text);
                    cmp.rerenderList();
                    //return;
                }
                else{
                    var text = 'Record not updated';
                    helper.selectErrorToast(cmp,event,helper,text);
                    //alert('record not updated');
                }   
            }else if(state === "ERROR"){
                var errors = response.getError();
                console.error(JSON.stringify(errors));
            }
            
        });
        $A.enqueueAction(action);
        
    },
})