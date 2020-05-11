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
    parseSales : function(component,file,batchNo,helper) {
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
            var header = 'Retailer_Code__c,Mainetti_Company__c,Sales_Model__c,Country__c,Source__c,Sales_Local__c,Unit_Sold__c,UOM__c,Local_Currency__c,ExRate_to_EUR__c,ExRate_to_USD__c,Year__c,Month__c,Week__c';
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
    closeSuccessModal: function(component, event, helper) {
        var modal = component.find("salesSuccessModal");
        var modalBackdrop = component.find("salesSuccessBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    openSuccessModal: function(component, event, helper) {
        var modal = component.find("salesSuccessModal");
        var modalBackdrop = component.find("salesSuccessBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeErrorModal: function(component, event, helper) {
        var modal = component.find("salesErrorModal");
        var modalBackdrop = component.find("salesErrorBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    openErrorModal: function(component, event, helper) {
        var modal = component.find("salesErrorModal");
        var modalBackdrop = component.find("salesErrorBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    uploadAzureWindowForFileUpload: function(component,helper,batchNo) {
        component.set("v.toggleSpinner", false);
        var w = 460;
        var h = 250;
        var left = Number((screen.width/2)-(w/2));
        var tops = Number((screen.height/2)-(h/2));
        var winObjct = window.open('/apex/azureInventoryFileUpload?Id=' + batchNo,'Inventory Data Upload','width=' + (parseInt(window.innerWidth) * 0.4) + ',height=' + (parseInt(window.innerHeight) * .6) + ',toolbar=0,menubar=0,location=0,status=0,scrollbars=0,resizable=0,left='+left+',top='+tops);
    },
    openWarningModal: function(component, event, helper) {
        var modal = component.find("salesModal");
        var modalBackdrop = component.find("salesModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeWarningModal: function(component, event, helper) {
        var modal = component.find("salesModal");
        var modalBackdrop = component.find("salesModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    inLineEditModal: function(component, event, helper) {
        var modal = component.find("inLineEditModal");
        var modalBackdrop = component.find("inLineEditModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeEditModal: function(component, event, helper) {
        var modal = component.find("inLineEditModal");
        var modalBackdrop = component.find("inLineEditModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    searchHelper : function(component,event,getInputkeyWord,mapFromValue,rawDataField,company) {
	  // call the apex class method 
     var action = component.get("c.fetchLookupErrorMapList");
      // set param to method       
        action.setParams({
            'mapToValue': getInputkeyWord,
            'mapFromValue': mapFromValue,
            'rawDataField': rawDataField,
            'company': company
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {                
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
        $A.enqueueAction(action);
    
	},
    //this function checks data is clean or not? (for the purpose of showing proceed after the data which is been edited).
    checkMissingWeek : function(component,helper,batchId) {
                
        var cleanData=component.get("c.isCompanyMissingWeek");                    
            cleanData.setParams({
                batchid: batchId
            }); 
            cleanData.setCallback(this,function (responseErr) {
                var state = responseErr.getState();
                if (state === "SUCCESS") {                    
                    var res=responseErr.getReturnValue();  
                    if(res == ""){
                        helper.proceedAfterEdit(component,helper,batchId);
                    }                    
                } else if (state === "ERROR") {
                    var errors = responseErr.getError();
                    console.error(errors);
                }
            });
            $A.enqueueAction(cleanData); 
        
        
    },
    proceedAfterEdit : function(component,helper,batchId) {
                
        var cleanData=component.get("c.isDataCleanForProceed");                    
            cleanData.setParams({
                batchid: batchId
            }); 
            cleanData.setCallback(this,function (responseErr) {
                var state = responseErr.getState();
                if (state === "SUCCESS") {                    
                    var res=responseErr.getReturnValue();  
                    if(res == ""){
                      //  helper.autoProceed(component, event, helper);
                       helper.processUploadingOfData(component,event,helper,batchId);
                    }
                    
                } else if (state === "ERROR") {
                    var errors = responseErr.getError();
                    console.error(errors);
                }
            });
            $A.enqueueAction(cleanData);    
    },
    autoProceed: function(component, event, helper) {
        // opening Azure file Upload        
        var batchId = component.get("v.salesProceedBatchId");   
        var action = component.get("c.recStatusUpsertForSales"); 
        action.setParams({
            "batchid" : batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    helper.uploadAzureWindowForFileUpload(component,helper,batchId);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                helper.openErrorModal(component,helper); 
            }
        });
        $A.enqueueAction(action);      
    },
    getErrorData: function(component, event, helper,batchId,page){
        var page = component.get("v.page") || 1; 
        var recordToDisplay = component.get("v.recordToDisplay");
        var actionError=component.get("c.getConciseSalesErrorData");
        actionError.setParams({
            "batchid": batchId,
            "pageNumber" : page,
            "recordToDisplay" :recordToDisplay
        }); 
        actionError.setCallback(this,function (responseErr) {
            var state = responseErr.getState();
            if (state === "SUCCESS") {                    
                var res=responseErr.getReturnValue();
                component.set("v.errordata", res);
                helper.checkMissingWeek(component,helper,batchId);
            } else if (state === "ERROR") {
                var errors = responseErr.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(actionError);
    },
    // For Pagination
    getSalesTransStageList: function(component, pageNumber, pageSize,batchId,totalRecords) {
        //alert('INSIDE getSalesTransStageList '+batchId);
        console.log('1:::'+batchId);
         var pageSize = component.find("pageSize").get("v.value");
        console.log('2');        
         var totalRecords = component.get("v.TotalRecords");
        console.log('3');
        var action = component.get("c.getSalesTranscationData");  
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "batchId": batchId,
            "totalRecords":totalRecords
        });
        action.setCallback(this, function(result) {
            console.log('4');
            var state = result.getState();
            if ( state === "SUCCESS"){
                console.log('5');
                var resultData = result.getReturnValue();
                component.set("v.errordata", resultData.salesTransStageList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                var isProceed = resultData.isProceed;
                console.log('INSIDE ######################### getSalesTransStageList isProceed:::::'+isProceed)
                if(isProceed){
                    //  helper.autoProceed(component, event, helper);
                    helper.processUploadingOfData(component,event,helper,batchId);
                }
            }
        });
        $A.enqueueAction(action);
    },  
    // Pasting the Sales Admin Access
        processUploadingOfData: function(component,event,helper,batchId) {
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:BatchMasterForSales"
        });
        evt.fire();
       
        var action = component.get("c.recStatusUpsertForInventory"); 
        action.setParams({
            "batchid" : batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    helper.updateInvSuccessCheckbox(component,event,helper,batchId);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                //helper.openErrorModal(component,helper); 
            }
        });
        $A.enqueueAction(action);      
    },
    updateInvSuccessCheckbox: function(component,event,helper,batchId) {
        var action = component.get("c.recUpdateFOrInvSuccess"); 
        action.setParams({
            "batchid" : batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                  //  helper.uploadAzureWindowForFileUpload(component,helper,batchId);
                  var text = 'Data is Getting Processed in the BackGround, Once Completed You will Receive a Email Notification';
                  helper.successToast(component,event,helper,text);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                //helper.openErrorModal(component,helper); 
            }
        });
        $A.enqueueAction(action); 
    }, successToast: function(component,event,helper,text){
        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Success!",
                            message: text,
                            type: "success",
                            mode:"pester"
                        });
                        toastEvent.fire();
    },
     openFileDataSubmittedModal: function(component, event, helper) {
        component.set("v.openFileDataSubmitted",true);
        var modal = component.find("openFileDataSubmitted");
        var modalBackdrop = component.find("openFileDataSubmittedBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open"); 
        
    },
    closeModalopenFileDataSubmittedModal: function(component, event, helper) {
        
        component.set("v.openFileDataSubmitted",false);
        var modal = component.find("openFileDataSubmitted");
        var modalBackdrop = component.find("openFileDataSubmittedBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
  
})