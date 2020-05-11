({
    init : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Warehouse', fieldName: 'Warehouse_Name__c', type: 'text'},
            {label: 'Retailer', fieldName: 'Retailer_Name__c', type: 'text'},
            //{label: 'Inventory Allocation Type', fieldName: 'Inventory_Allocation_Type__c', type: 'text'},
            {label: 'Quantity', fieldName: 'Quantity__c', type: 'number'},
            //{label: 'Week Start Date', fieldName: 'Week_Start_Date__c', type: 'Date'},
            //{label: 'Week End Date', fieldName: 'Week_End_Date__c', type: 'Date'} 
        ]);
        
        var action = component.get("c.fetch");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.mydata", response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handleRowAction : function(component, event,helper){
        component.set("v.buttonEnable",true);
        var selRows = event.getParam('selectedRows');
        //alert(selRows);
        var idList = [];
        for(var i=0;i<selRows.length;i++){
               //alert(selRows[i].Id); 
            idList.push(selRows[i].Id);
             
         }        
       component.set("v.Id",idList);
      
    },
    doCancel : function(component, event, helper){
        //component.rerenderList();
        //window.location.reload();
        component.set("v.buttonEnable",false);
        component.rerenderList();
        var uncheck = component.get("v.Id");
       // alert(uncheck);
       // for(uncheck IDs : )
        
        
    },
    
    doSave : function(component, event, helper){
        var value = component.get("v.Id");
         var action = component.get("c.save");
        //alert(value);
        //return;
        action.setParams({
            "checkedId": value
        	});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var status =response.getReturnValue();
                //alert(status);
                if(status == true){
                    component.rerenderList();
                    var text = 'Checked successfully.';
                    helper.successToast(component,event,helper,text);
                    component.rerenderList();
                    //var text = 'Company deleted successfully.';
                    //helper.successToast(component,event,helper,text);
                }
               // console.log(response.getReturnValue());
                //alert('Checked Succusfully');
                //component.set("v.mydata", response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);

    }    
})