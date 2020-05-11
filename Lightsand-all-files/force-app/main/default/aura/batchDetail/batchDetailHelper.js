({
    invoke : function(component,helper) {
        var action=component.get("c.getData");
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
    
    getMainettiCompanyPicklist: function(component, event) {
        var action = component.get("c.getMainettiMap");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var recordStatusMap = [];
                for(var key in result){
                    recordStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.mainettiCompanyMap", recordStatusMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getRecordStatusPicklist: function(component, event) {
        var action = component.get("c.getRecordStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var recordStatusMap = [];
                for(var key in result){
                    recordStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.recordStatusMap", recordStatusMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getBatchStatusPicklist: function(component, event) {
        var action = component.get("c.getBatchStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var batchStatusMap = [];
                for(var key in result){
                    batchStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.batchStatusMap", batchStatusMap);
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
    
    parseFile : function(component,file,batchNo,helper) {
        var recordType = component.get("v.selectedRecordType");
        var company = component.get("v.selectedMainettiCompany");
        var complete = $A.getCallback(function(results) {           
            var myJson = JSON.stringify(results.data);            
            var action = component.get("c.parse");
            action.setParams({
                "jsonin": myJson,
                "batchNo": batchNo,
                "recordType": recordType,
                "company": company
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    component.set("v.toggleSpinner", false);
                    console.log('error callback post creation of Master Record:'+ errors[0].message);
                    helper.openErrorModal(component,helper);                   
                }                
                if (state === "SUCCESS") {
                    component.rerenderList();
                    var batchId =response.getReturnValue();                   
                    if(batchId != ''){
                        // opening Azure file Upload
                        var csv = Papa.unparse(myJson);
                        var file =  component.find("file").getElement().files[0];
                        var fileName = file.name;
                        helper.createDocument(component,helper,batchId,csv,fileName);                      
                    }else{
                        helper.openErrorModal(component,helper);
                    }                 
                }
            });
            $A.enqueueAction(action);
        })
        
        var reader = new FileReader();        
        reader.onload = function(event) {
            var contents = event.target.result;           
            var header = 'Retailer_Code__c,Mainetti_Company__c,Inventory_Model__c,Warehouse__c,Color__c,Sizer_Print__c,Local_System_SKU__c,Source__c,Stock_In_Date__c,Stock_In_Qty__c';
            var csvString = header+'\n'+contents;
            Papa.parse(csvString,{
                header: true,
                complete: complete});            
        };
        
        reader.onerror = function(event) {
            console.error("File could not be read! Code " + event.target.error.code);
        };
        var file =  component.find("file").getElement().files[0];
        reader.readAsText(file);        
        this.closeModal(component,helper);
    },
    
    createDocument: function(component,helper,batchId,csv,fileName) {
        var action = component.get("c.createDocument");
        action.setParams({
            "csv": csv,
            "fileName": fileName,
            "batchNo":batchId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var errors = response.getError();
            if (errors && Array.isArray(errors) && errors.length > 0) {
                console.log('error'+ errors[0].message);
                alert("state"+errors[0].message);
            }                
            if (state === "SUCCESS") {
                var status =response.getReturnValue();
                if(status){
                    // opening Azure file Upload
                    helper.uploadAzureWindowForFileUpload(component,helper,batchId);                        
                }else{
                }                                  
            }
        });
        $A.enqueueAction(action);
    },
    
    openModal: function(component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeModal: function(component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    openErrorModal: function(component, event, helper) {
        var modal = component.find("inventoryErrorModal");
        var modalBackdrop = component.find("inventoryErrorModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeErrorModal: function(component, event, helper) {
        var modal = component.find("inventoryErrorModal");
        var modalBackdrop = component.find("inventoryErrorModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    uploadAzureWindowForFileUpload: function(component,helper,batchNo) {
        component.set("v.toggleSpinner", false);
        var w = 460;
        var h = 375;
        var left = Number((screen.width/2)-(w/2));
        var tops = Number((screen.height/2)-(h/2));
        var winObj = window.open('/apex/azureInventoryFileUpload?Id=' + batchNo, 'Inventory Data Upload','directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=false,width='+w+', height='+h+', top='+tops+', left='+left);
    }
})