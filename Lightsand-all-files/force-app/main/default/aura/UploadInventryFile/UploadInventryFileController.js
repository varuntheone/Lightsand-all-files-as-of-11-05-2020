({
    show : function(component, event, helper) {
        component.set("v.toggleSpinner", false);
        helper.invoke(component,helper);
        helper.getRecordStatusPicklist(component, event);
        helper.getBatchStatusPicklist(component, event);
        helper.getMainettiCompanyPicklist(component, event);        
    },
    
    doInit : function(component) {
        var vfOrigin = "https://" + component.get("v.vfHost");
        window.addEventListener("message", function(event) {
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                return;
            }
            // Handle the message
            if (event.data === 'Refresh') {
                window.location.reload();
            }
        }, false);
    },
    
    handleSearchClick : function(component, event, helper) {
        var fDate = component.get("v.fromdate");
        var tDate = component.get("v.todate");
        var recordstatus = component.get("v.record.Record_Type__c");
        var batchstatus = component.get("v.record.Batch_Status__c");
        var company = component.get("v.cmp.Name");
        if (company== "") {
            alert("Please Select Mainetti Company!");
            return;
        }        
        var action=component.get("c.getDateandTypeRecords");
        action.setParams({
            "fromDate": fDate,
            "toDate": tDate,
            "recordStatus": recordstatus,
            "batchStatus": batchstatus,
            "mainettiCmp": company            
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    initRecordType : function(component, event, helper) {
        var action=component.get("c.getRecordType");
        
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.options", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleMainettiCmpOnChange : function(component, event, helper) {
        var company = component.get("v.cmp.Name");
        var set= component.set("v.selectedMainettiCompany",company);
        var get = component.get("v.selectedMainettiCompany");
    },
    
    //handle RecordStatus Picklist Selection
    handleRecordStatusOnChange : function(component, event, helper) {
        var recordstatus = component.get("v.itm.Record_Type__c");
        var set= component.set("v.selectedRecordType",recordstatus);
        var get = component.get("v.selectedRecordType");
    },
    
    
    // function to get the error details of Inventory_Transaction_Stage__c.    
    viewError : function(component, event, helper) {        
        component.set("v.flag",true);
        var batchId = event.getSource().get("v.name");
        var actionError=component.get("c.getErrorData");
        actionError.setParams({
            batchid: batchId
        });      
        
        actionError.setCallback(this,function (responseErr) {
            var state = responseErr.getState();
            if (state === "SUCCESS") {
                var res=responseErr.getReturnValue();
                component.set("v.errordata", res);
            } else if (state === "ERROR") {
                var errors = responseErr.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(actionError);        
    },    
    
    handleParseClick : function(component, event, helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var MAX_FILE_SIZE= 9500000;
        var recordstatus = component.get("v.itm.Record_Type__c");
        var mainettiCmp = component.get("v.cmp.Name");
        if (recordstatus== "") {
            alert("Please Select Record type!");
            return;
        }
        if (mainettiCmp== "") {
            alert("Please Select Mainetti Company!");
            return;
        }
        if (fileInput.value == "") {
            alert("You forgot to attach file!");
            return;
        }
        if(file.type!= 'application/vnd.ms-excel'){
            alert('Enter a valid file');
            return;
        }
        if (file.size > MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + MAX_FILE_SIZE + ' bytes.\n' +
                  'Selected file size: ' + file.size);
            return;
        }
        var batchNo=component.get("v.reuploadBatchNo");
        component.set("v.toggleSpinner", true);
        helper.parseFile(component,file,batchNo,helper);
    }, 
    
    newUpload: function(component, event, helper) {
        component.set("v.reuploadBatchNo", '');
        helper.openModal(component,helper);
    },
    
    closeModal: function(component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    
    closeErrorModal: function(component, event, helper) {
        helper.closeErrorModal(component,helper);
    },
    
    reuploadfile: function(component, event, helper) {
        var batchId = event.getSource().get("v.name");
        component.set("v.reuploadBatchNo", batchId);
        helper.openModal(component,helper);
    } 
})