({
	 show : function(component, event, helper) {
        component.set("v.toggleSpinner", false);
        helper.defaultSales(component, helper);
        //helper.invoke(component,helper);
        helper.getRecordStatusPicklist(component, event);
        //helper.getBatchStatusPicklist(component, event);
        //helper.getMainettiCompanyPicklist(component, event);
        helper.getYear(component, event); 
        helper.month(component, event, helper);
        helper.getSalesCountryPicklist(component, event);
        helper.currentMonthYear(component, event);
    },
    newUpload: function(component, event, helper) {
        helper.openModal(component,helper);
    },
    closeModal: function(component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    handleRecordTypeSearchOnChange : function(component, event, helper) {
        var recType = component.get("v.record.Record_Type__c");
        var set= component.set("v.recordTypeSearch",recType);
        var get = component.get("v.recordTypeSearch");        
    },    
   /* handleMainettiCmpOnChange : function(component, event, helper) {
        var company = component.get("v.cmp.Name");
        var set= component.set("v.selectedMainettiCompany",company);
        var get = component.get("v.selectedMainettiCompany");        
    },*/
     //Onchange for Sales Minetti Company 
    handleSalesCmpOnChange : function(component, event, helper) {
        var companysales = component.get("v.cmpsales.Name");
        var set= component.set("v.selectedSalesCompany",companysales);
        var get = component.get("v.selectedSalesCompany");        
    },
    //handle RecordStatus Picklist Selection
    handleRecordStatusOnChange : function(component, event, helper) {
        var recordstatus = component.get("v.itm.Record_Type__c");
        var set= component.set("v.selectedRecordType",recordstatus);
        var get = component.get("v.selectedRecordType");        
    },
    handleMonthListOnChange : function(component, event, helper) {
        var month = component.find('monthList').get('v.value');   
        var set= component.set("v.selectedValues",month);        
    },
    handleYearOnChange : function(component, event, helper) {
        var year = component.find('yearDynamicList').get('v.value');  
        var set= component.set("v.selectedYear",year);
    },     
    generateBatchId : function(component, event, helper) {
        component.set("v.toggleSpinner", true);
        helper.generateSalesBatchId(component,helper);
    },
    handleUploadFinished: function (cmp, event) {
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File "+fileName+" Uploaded successfully."
        });
        toastEvent.fire();
        
        $A.get('e.lightning:openFiles').fire({
            recordIds: [documentId]
        });
        
    }
})