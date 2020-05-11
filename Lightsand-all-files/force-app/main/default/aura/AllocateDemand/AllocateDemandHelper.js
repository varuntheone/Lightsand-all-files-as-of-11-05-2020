({
    
    /*userPermission : function(component, event, helper) {
        var retailer = component.get("v.retailer");
        
        var action=component.get("c.userPermission");
        action.setParams({
            "retailer": retailer
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result == true){
                    // result returns true when the user is allocated for a perticular retailer.
                    helper.initializeDataTable(component, event, helper);
                }else{
                    var text = "User dont have access to Allocate";
                    helper.selectErrorToast(component,event,helper,text);
                    window.history.go(-1);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
        
    },*/
    
	initializeDataTable : function(component, event, helper) {
        component.set('v.Columns', [
            {label: 'Retailer', fieldName: 'retailerCode', type: 'text'},
            {label: 'Model', fieldName: 'model', type: 'text'},
            {label: 'Color', fieldName: 'color', type: 'text'},
            {label: 'Sizer Print', fieldName: 'sizerPrinter', type: 'text'},
            {label: 'Balance Quantity', fieldName: 'totalBalance', type: 'number'},
            //{ type: 'action', typeAttributes: { rowActions: 'actions' } }
            
        ]);
            
            
        var sourceObject = component.get("v.sourceObj");
            //alert(sourceObject);
            if(sourceObject == 'Supply'){
            	helper.initializeDataFromSupply(component, event, helper);
            }else if(sourceObject == 'Demand'){
            	helper.initializeDataFromDemand(component, event, helper);
            }
        
    },

	initializeWarehouseDataTable : function(component, event, helper) {
        component.set('v.warehouseColumns', [
            {label: 'Warehouse', fieldName: 'warehouse', type: 'text'},
            {label: 'Retailer', fieldName: 'retailer', type: 'text'},
            {label: 'Model', fieldName: 'model', type: 'text'},
            {label: 'Color', fieldName: 'color', type: 'text'},
            {label: 'Sizer Print', fieldName: 'print', type: 'text'},
            //{label: 'Balance Quantity', fieldName: 'totalBalance', type: 'number'},
            //{ type: 'action', typeAttributes: { rowActions: 'actions' } }
            
        ]);
        //helper.initializeWarehouse(component, event, helper);
        
    },            
      
    initializeWarehouse : function(component, event, helper) {
        	helper.initializeWarehouseDataTable(component, event, helper);
            var retailer = component.get("v.retailer");
            var model = component.get("v.model");
            var color = component.get("v.color");
            var sizerPrint = component.get("v.sizerPrint");
            var warehouse = component.get("v.warehouse");
        	var supplyId = component.get("v.supplyId");
            
        	/*
        	 * alert("supplyId:"+supplyId+"\n"+
              "retailer:"+retailer+"\n"+
              "model:"+model+"\n"+
              "color:"+color+"\n"+
              "sizerPrint:"+sizerPrint+"\n"+
              "warehouse:"+warehouse+"\n"
             );
             */
        
            var action=component.get("c.listWarehouse");
        	action.setParams({
            "retailer": retailer,
            "model": model,
            "color": color,
            "sizerPrint": sizerPrint,
            "warehouse": warehouse
        	});
        	action.setCallback(this,function (response) {
            	var state = response.getState();
            	if (state === "SUCCESS") {
                	var result = response.getReturnValue();
                    //alert(result);
                    if(result == ''){
                        component.set("v.disableSave",true);
                    }
            		component.set("v.warehouseList",result); 
            	} else if (state === "ERROR") {
                	var errors = response.getError();
                	console.error(errors);
            	}
        	});
        	$A.enqueueAction(action);
            
    },
            
            
            
    // Initialize supply data by passing demand id.
    initializeDataFromDemand : function(component, event, helper) {
        var demandId = component.get("v.demandId");    
            
		var action=component.get("c.getDataFromDemand");
        action.setParams({
            "demandId": demandId
        });    
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
            	component.set("v.data",result.DemandForecastListToDisplay);            	
            
                for (var i = 0; i < result.DemandForecastListToDisplay.length; i++) {
            		component.set("v.supplyId",result.DemandForecastListToDisplay[i].weeklySupplyId);
                    component.set("v.avlQuantity",result.DemandForecastListToDisplay[i].totalBalance);
                    component.set("v.warehouseForSave",result.DemandForecastListToDisplay[i].warehouse);
            	}                                   
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
	},
    
    // Initialize supply data by passing supply id.
    initializeDataFromSupply : function(component, event, helper) {
        
        var supplyId = component.get("v.supplyId");
        //alert('supplyId:'+supplyId);
		var action=component.get("c.getDataFromSupply");
        action.setParams({
            "supplyId": supplyId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.data",result.DemandForecastListToDisplay);
            	//alert("alert1");
            	for (var i = 0; i < result.DemandForecastListToDisplay.length; i++) {
                    //alert("result:"+result.DemandForecastListToDisplay[i].weeklyDemandId);
            		component.set("v.demandId",result.DemandForecastListToDisplay[i].weeklyDemandId);
                    component.set("v.avlQuantity",result.DemandForecastListToDisplay[i].totalBalance);
                    //component.set("v.warehouseForSave",result.DemandForecastListToDisplay[i].warehouse);
            	}
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
	},
     
        saveAllocation : function(component, event, helper, enterQty, supplyId, demandId, warehouseSupplyId) {
            
            var allocataionType ='Demand';
            var warehouseForSave = component.get("v.warehouseForSave");
            
            // allocataionType will be supply only when there is an allocation from one virgin another virgin.
            var forSourceToSource = component.get("v.isSourceToSource");
            if(forSourceToSource){
                allocataionType ='Supply';
            }
                        
            var action=component.get("c.saveAllocation");
            action.setParams({
                "quantity": enterQty,
                "supplyId": supplyId,
                "demandId": demandId,
                "allocataionType": allocataionType,
                "warehouseSupplyId": warehouseSupplyId,
                "warehouseForSave": warehouseForSave
            });
            action.setCallback(this,function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if(result == true){
                        //window.history.go(-1);
                        //To close the model popup.
                        var modalEvent = component.getEvent("modalCommunication");        
                        modalEvent.fire();
                        var text = 'Allocated Successfully'
                        helper.successToast(component,event,helper,text);
                    }
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            });
            $A.enqueueAction(action);
        },
            selectErrorToast: function(component,event,helper,text){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: text,
                    type: "error",
                    mode:"sticky"
                });
                toastEvent.fire();
            },
                successToast: function(component,event,helper,text){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success!",
                        message: text,
                        type: "success",
                        mode:"pester"
                    });
                    toastEvent.fire();
                },
})