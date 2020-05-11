({
	generateSalesBatchId : function(component,helper) {
        //alert('1');
		     var recordType = component.get("v.selectedRecordType");  
         //alert('1.2');
            var selMonthNum = component.get("v.selectedValues");
         //alert('1.3');
            var selYear = component.get("v.selectedYear");
        //alert('1.4');
            var selCompany = component.get("v.cmpsales.Name");
            var monthsList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            var date = new Date();
            var selMonth = monthsList[selMonthNum];
            var currentMonth = monthsList[date.getMonth()]; 
             
         //alert('2');
            if(selCompany == ""){
                document.getElementById('errorMissing').innerHTML='Please Select the Country!';                    
                component.set("v.toggleSpinner", false);
                return;
            }
            if(selMonthNum == ""){
                document.getElementById('errorMissing').innerHTML='Please Select a Month!';                    
                component.set("v.toggleSpinner", false);
                return;
            }
            if(selYear == ""){
                document.getElementById('errorMissing').innerHTML='Please Select a Year!';                    
                component.set("v.toggleSpinner", false);
                return;
            }         
            //var getAppName = component.get("v.appName");
            var the_month = date.getMonth();
            var currentYear =   date.getYear();              
            var month = component.find('monthList').get('v.value');
            var isreupload  = component.get("v.isReupload");
         
            if(selYear == currentYear && !isreupload ){
                if (month > the_month) {
                    document.getElementById('errorMissing').innerHTML='Please select a valid moth for your request.\nThe current selection occurs after the current month.';                
                    component.set("v.toggleSpinner", false);
                    return;
                } 
            }   
         alert('3');
            //var presentMonthNum = date.getMonth();  
        var action=component.get("c.generateIdForFileUpload");             
        action.setParams({
            "recordType": recordType,
            "selMonth": selMonth,
            "selYear": selYear,
            "selcomp": selCompany                      
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.toggleSpinner", false);
                var batchId = response.getReturnValue();
                console.log('Return Batch Id::::'+batchId);
                component.set("v.attachBatchRecordId",batchId);
                component.set("v.batchIdExists", true);               
                
            } else if (state === "ERROR") {
                component.set("v.toggleSpinner", false);
                var errors = response.getError();
                console.error(errors);
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
    defaultSales:function(component,helper)
    {
        component.set("v.appName", "SalesUpload");
        component.set("v.itm.Record_Type__c","Sales");
        component.set("v.selectedRecordType","Sales");
    },
     month: function (component, event, helper) {
        helper.monthDynamic(
            $A.getCallback(function handleServerResponse(serverResponse) {
                component.set('v.optionss', serverResponse.month);
            })
        );
        var date = new Date();      
        var defaultMonth = date.getMonth();
    },    
    monthDynamic: function (onResponse) {
        setTimeout(function () {
            var serverResponse = {
                //selectedColorId: 2,
                month: [
                    { id: 0, label: 'Jan' },
                    { id: 1, label: 'Feb'} ,
                    { id: 2, label: 'Mar'},
                    { id: 3, label: 'Apr'},
                    { id: 4, label: 'May'},
                    { id: 5, label: 'Jun'},
                    { id: 6, label: 'Jul'},
                    { id: 7, label: 'Aug'},
                    { id: 8, label: 'Sep'},
                    { id: 9, label: 'Oct'},
                    { id: 10, label: 'Nov'},
                    { id: 11, label: 'Dec'}
                    
                ]
            };
            onResponse.call(null, serverResponse);
        }, 2000);
    },    
    currentMonthYear : function(component,helper) {
        var date = new Date();
        var currentMonth = date.getMonth();
        var currentYear = date.getFullYear();
        component.set("v.selectedValues", currentMonth);
        component.set("v.selectedYear", currentYear);
    },
   getYear : function(component,helper) {        
        var action=component.get("c.getPreviousYear");
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearList", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    }, 
    /*
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
    },*/
     getSalesCountryPicklist: function(component, event) {
        var action = component.get("c.getsalesCompanyList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                var partnerCompanyMap = [];
                for(var key in result){
                    partnerCompanyMap.push({key: key, value: result[key]});
                }
                component.set("v.SalesCompanyMap", partnerCompanyMap);
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
    
   /* getBatchStatusPicklist: function(component, event) {
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
    },*/
    
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
    }
})