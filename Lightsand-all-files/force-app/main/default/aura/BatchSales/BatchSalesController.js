({        
    // function to get the error details of Sales_Transaction_Stage__c.    
    viewError : function(component, event, helper) {
        // Using for Pagination
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize"); 
        var totalRecords = component.get("v.TotalRecords");
      
        var params = event.getParam('arguments');
        component.set("v.flag",true);
        component.set("v.noRows",false);
        var salesProceedBatchId = component.get("v.salesProceedBatchId");
        
        var salesBatchId;        
        if(params ==""){      
            salesBatchId = salesProceedBatchId;            
        }else{            
            salesBatchId = params.batchId;
        }
        if (salesBatchId) {
            component.find('salesError').focus();
//alert('salesBatchId'+salesBatchId);
            var batchId = salesBatchId;              
            component.set("v.salesProceedBatchId",batchId);            
            component.set("v.proceedStatus",false);
            var actionProceed = component.get("c.proceedSalesData");
            //alert('salesBatchId'+salesBatchId);
            actionProceed.setParams({
                "batchid": batchId      
            });
            actionProceed.setCallback(this,function (responseErr) {
                var state = responseErr.getState();
                if (state === "SUCCESS") {                                
                    var result = responseErr.getReturnValue();
                    if(result!=null && result!=''){ 
                         
                        if(result.indexOf("#")>0){
                        var proceedStatus = result.substring(0,result.indexOf("#"));
                        var missingWeekStatus = result.substring(result.indexOf("#")+1);
                       
                        if(proceedStatus == 'true'){    
                            
                            component.set("v.messageProceedStatus",true);
                            component.set("v.proceedStatus",true);
                            helper.openWarningModal(component,helper);
                        }else {
                            component.set("v.messageProceedStatus",false);
                            component.set("v.proceedStatus",false);                            
                        }
                        if(missingWeekStatus == 'true'){                            
                            component.set("v.companyWeekStatus",true);
                            component.set("v.proceedStatus",true);
                            helper.openWarningModal(component,helper);
                        }else {
                            component.set("v.companyWeekStatus",false);
                        }
                        }else{
                        component.set("v.noRows",true);
                        }
                    }
                } else if (state === "ERROR") {
                    var errors = responseErr.getError();
                    
                    console.error(errors);
                }
            });
            $A.enqueueAction(actionProceed);
           // helper.getSalesTransStageList(component, pageNumber, pageSize,batchId,totalRecords);
            //     helper.checkMissingWeek(component,helper,batchId);
            
        }                    
        
    },
    closeErrorModal: function(component, event, helper) {
        helper.closeErrorModal(component,helper);
    },
    closeSuccessModal: function(component, event, helper) {
        helper.closeSuccessModal(component,helper);
    },
    proceedClick: function(component, event, helper) {
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
                helper.openFileDataSubmittedModal(component,helper);
                //if(status){
                  //  helper.uploadAzureWindowForFileUpload(component,helper,batchId);
                //}
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                helper.openErrorModal(component,helper); 
            }
        });
        $A.enqueueAction(action);      
    },
    openWarningModal: function(component, event, helper) {
        var modal = component.find("salesModal");
        var modalBackdrop = component.find("salesModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeWarningModal: function(component, event, helper) {
        var proceedStatus = component.get("v.proceedStatus");
       /* if(proceedStatus)
        {
            component.find('cursor').focus();
        }*/
        var modal = component.find("salesModal");
        var modalBackdrop = component.find("salesModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    
    closeWarningCanecelModal: function(component, event, helper) {
        var modal = component.find("salesModal");
        var modalBackdrop = component.find("salesModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    saveErrorMap:function(component,event,helper)
    {
       var divName = document.getElementById('display');
        var errMapValue = divName.value
        var recordId =  divName.name;
         
        var selectedSearchResultValue = component.get("v.selectedRecord");
        var serValue = component.find('searchValue').get('v.value');
        var divValule = document.getElementById('valueHolder');
        var errMapTypeName = divValule.name; 
        var companyName = divValule.value;
        var mapToValue='';
        var serachBoolean = false;
        var searchSelectValue = selectedSearchResultValue.Map_To_Value__c;
        
        //alert('searchSelectValue:::'+searchSelectValue+'::serValue::'+serValue);
        if((searchSelectValue != null && searchSelectValue !='')){
            mapToValue = searchSelectValue; 
            serachBoolean = true;
        }else if((serValue != null && serValue != '')){
            if(!serachBoolean){
            	mapToValue = serValue;
            }
        }
        if(mapToValue != ''){
            
            var hdnErrorMapFields = document.getElementById('errorMapFields');
            var errMap = hdnErrorMapFields.value;        
            helper.closeEditModal(component,helper); 
            var batchId = component.get("v.salesProceedBatchId");
            var action = component.get("c.saveRecord"); 
            action.setParams({
                "recordType":errMapTypeName,
                "newValue" : mapToValue,           
                "oldValue" : errMapValue,
                "batchId": batchId,
                "recordId" : recordId,
                "errMap" : errMap,
                "pickListToRemove" :errMapTypeName,
                "companyName":companyName
            });
            action.setCallback(this,function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {                
                    var status =response.getReturnValue();
                    if(status){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Success",
                            message: 'Record Inserted Successfully',
                            type: "success",
                            mode:"sticky"
                        });
                        toastEvent.fire();
                        component.rerenderList();
                    }else{
                        helper.openErrorModal(component,helper); 
                    }
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                    helper.openErrorModal(component,helper); 
                }
            });
            $A.enqueueAction(action);
        }else{
            document.getElementById('errorMissing').innerHTML='Enter MapToValue Field data';
            
        }        
    },
    inLineEdit: function(component, event, helper) {
        component.set("v.SearchKeyWord","");
        var errorName = event.getSource().get("v.name");
        var errorValue = event.getSource().get("v.value");        
        var errorType = errorName.substring(0,errorName.indexOf("#"));
        var errorId = errorName.substring(errorName.indexOf("#")+1);
        var errMap = document.getElementById(errorName);
        
        var errMapValue = errMap.value; 
        var errMapTypeNameAndCompanyName = errMap.name; 
        var errMapTypeName = errMapTypeNameAndCompanyName.substring(0,errMapTypeNameAndCompanyName.indexOf("#"));
        var errMapCompanyName = errMapTypeNameAndCompanyName.substring(errMapTypeNameAndCompanyName.indexOf("#")+1);
        var hdnErrorMapFields = document.getElementById('errorMapFields');
        hdnErrorMapFields.value=errorValue;
        var divName = document.getElementById('display');
        divName.value = errMapValue;
        divName.name = errorId;
        var divValue = document.getElementById('valueHolder'); 
        divValue.name = errMapTypeName;
        divValue.value = errMapCompanyName;
         document.getElementById('customerdataLabel').innerHTML=errMapTypeName;      
        helper.inLineEditModal(component,helper); 
    },
    closeEdit: function(component, event, helper) {
        helper.closeEditModal(component,helper); 
    },
    sendingEvent: function(component, event, helper) {
        var actionProceed = component.get("v.salesProceedBatchId");
        var createEvent = component.getEvent("updateCommunication");
        createEvent.setParams({ "communication": actionProceed });
        createEvent.fire();
        helper.closeWarningModal(component,helper);
    },
    //Custom Lookup Family Controllers     
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){             
                var forOpen = component.find("searchRes");
                var mapFromValue = document.getElementById('display').value;
                var rawDataFieldCompany = document.getElementById('valueHolder'); 
                var rawDataField = rawDataFieldCompany.name;
                var company = rawDataFieldCompany.value;
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord,mapFromValue,rawDataField,company);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );   
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedSalesErrorMapGetFromEvent = event.getParam("salesErrorMapByEvent");
	   component.set("v.selectedRecord" , selectedSalesErrorMapGetFromEvent); 
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
	},
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var totalRecords = component.get("v.TotalRecords");
        var salesProceedBatchId = component.get("v.salesProceedBatchId");
        var batchId = salesProceedBatchId;
        pageNumber++;
        helper.getSalesTransStageList(component, pageNumber, pageSize,batchId,totalRecords);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var totalRecords = component.get("v.TotalRecords");
         var salesProceedBatchId = component.get("v.salesProceedBatchId");
        var batchId = salesProceedBatchId;
        pageNumber--;
        helper.getSalesTransStageList(component, pageNumber, pageSize,batchId,totalRecords);
    },
     
    onSelectChange: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber"); 
        var pageSize = component.find("pageSize").get("v.value");
        var totalRecords = component.get("v.TotalRecords");
        var salesProceedBatchId = component.get("v.salesProceedBatchId");
        var batchId = salesProceedBatchId;
        helper.getSalesTransStageList(component, pageNumber, pageSize,batchId,totalRecords);
    },
    closeModalopenFileDataSubmittedModal: function(component, event, helper) {
        helper.closeModalopenFileDataSubmittedModal(component,helper);
    },
    viewSalesErrorData: function(component, event, helper) {
        var salesProceedBatchId = component.get("v.salesProceedBatchId");        
        var batchId = salesProceedBatchId;  
       // var batchId = event.getSource().get("v.name");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SalesErrorComponent",
            componentAttributes: {
                batchId : batchId
            }
        });
        evt.fire();
    }
})