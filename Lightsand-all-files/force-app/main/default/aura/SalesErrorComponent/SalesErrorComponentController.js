({
    doInit : function(component, event, helper) {
        var batchId = component.get("v.batchId");
        //Check if the page is select or not, Default 1 
        var page = component.get("v.page") || 1;
        //var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        var recordToDisplay = 15; 
        //alert("1")
        component.set('v.errorColumns', [
            {label: 'Company', fieldName: 'Company__c', type: 'text',initialWidth: 200,cellAttributes: { class: { fieldName: 'Company_Formula__c' }}},
            {label: 'Year', fieldName: 'Year__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Year_Formula__c' }}},
            {label: 'Week', fieldName: 'Week__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Week_Formula__c' }}},
            {label: 'Month', fieldName: 'Month__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Month_Formula__c' }}},
            {label: 'Item_code', fieldName: 'Item_code__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Item_Code_Formula__c' }}},
            {label: 'Material', fieldName: 'Material__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Material_Formula__c' }}},
            {label: 'Source', fieldName: 'Source__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Source_Formula__c' }}},
            {label: 'Model', fieldName: 'Model__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Model_Formula__c' }}},
            {label: 'Printed_Logo', fieldName: 'Printed_Logo__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Printed_Logo_Formula__c' }}},
            {label: 'Color', fieldName: 'Color__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Color_Formula__c' }}},
            {label: 'Customer', fieldName: 'Customer__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Customer_Formula__c' }}},
            {label: 'Customer_local_name', fieldName: 'Customer_local_name__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Customer_Local_Name_Formula__c' }}},
            {label: 'Category', fieldName: 'Category__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Category_Formula__c' }}},
            {label: 'Sub Category', fieldName: 'Sub_Category__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Sub_Category_Formula__c' }}},
            {label: 'Family', fieldName: 'Family__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Family_Formula__c' }}},
            {label: 'Order_Type', fieldName: 'Order_Type__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Order_Type_Formula__c' }}},
            {label: 'Unit_Sold', fieldName: 'Unit_Sold__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Unit_Sold_Formula__c' }}},
            {label: 'Unit_Price_100_EUR', fieldName: 'Unit_Price_100_EUR__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Unit_Price_100_EUR_Formula__c' }}},
            {label: 'Unit_Price_100_USD', fieldName: 'Unit_Price_100_USD__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Unit_Price_100_USD_Formula__c' }}},
            {label: 'Net_Unit_Price_100', fieldName: 'Net_Unit_Price_100__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Net_Unit_Price_100_Formula__c' }}},
            {label: 'Sales_EUR', fieldName: 'Sales_EUR__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Sales_EUR_Formula__c' }}},
            {label: 'Sales_USD', fieldName: 'Sales_USD__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Sales_USD_Formula__c' }}},
            {label: 'Transaction_Currency', fieldName: 'Transaction_Currency__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Transaction_Currency_Formula__c' }}},
            {label: 'ExRate_to_EUR', fieldName: 'ExRate_to_EUR__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'ExRate_to_EUR_Formula__c' }}},
            {label: 'ExRate_to_USD', fieldName: 'ExRate_to_USD__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'ExRate_to_USD_Formula__c' }}},
            {label: 'Local_Net_Unit_Pirce_100', fieldName: 'Local_Net_Unit_Pirce_100__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Local_Net_Unit_Pirce_100_Formula__c' }}},
            {label: 'Sales_Transaction_Currency', fieldName: 'Sales_Transaction_Currency__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Sales_Transaction_Currency_Formula__c' }}},
            {label: 'Shipped_To_Factory', fieldName: 'Shipped_To_Factory__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Shipped_To_Factory_Formula__c' }}},            
            {label: 'Shipped_To_Country', fieldName: 'Shipped_To_Country__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Shipped_To_Country_Formula__c' }}},
            {label: 'Label', fieldName: 'Label__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Label_Formula__c' }}},
            {label: 'End_user', fieldName: 'End_user__c', type: 'text',initialWidth: 100},            
            {label: 'Vendor', fieldName: 'Vendor__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Vendor_Formula__c' }}},            
            {label: 'Division', fieldName: 'Division__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Division_Formula__c' }}},
            {label: 'Retailer_Brand', fieldName: 'Retailer_Brand__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Retailer_Brand_Formula__c' }}},
            {label: 'Royalty_Rate', fieldName: 'Royalty_Rate__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Royalty_Rate_Formula__c	' }}},
            {label: 'Market', fieldName: 'Market__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Market_Formula__c' }}},
            {label: 'Remark', fieldName: 'Remark__c', type: 'text',initialWidth: 100},
            {label: 'LOB', fieldName: 'LOB__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'LOB_Formula__c' }}},
            {label: 'SO_Number', fieldName: 'SO_Number__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'SO_Number_Formula__c' }}},
            {label: 'Production_Country', fieldName: 'Production_Country__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Production_Country_Formula__c' }}},
            {label: 'Gross_Sales_USD', fieldName: 'Gross_Sales_USD__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Gross_Sales_USD_Formula__c' }}},
            {label: 'Freight_Charge_USD', fieldName: 'Freight_Charge_USD__c', type: 'text',initialWidth: 100,cellAttributes: { class: { fieldName: 'Freight_Charge_USD_Formula__c' }}},
            {label: 'Remarks', fieldName: 'Remarks__c', type: 'textarea',initialWidth: 350}
        ]);            
        helper.initializeErrorData(component, event, helper, page, recordToDisplay,batchId);
    },
    handleSalesSearchClick : function(component, event, helper) {
        var batchId = component.get("v.batchId");
        //Check if the page is select or not, Default 1 
        var page = component.get("v.page") || 1;
        //var recordToDisplay = cmp.find("recordSize").get("v.value"); 
        var recordToDisplay = 15;
        var missingData = component.get("v.missingData");            
        helper.initializeErrorData(component, event, helper, page, recordToDisplay,batchId);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    }, 
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },        
    
})