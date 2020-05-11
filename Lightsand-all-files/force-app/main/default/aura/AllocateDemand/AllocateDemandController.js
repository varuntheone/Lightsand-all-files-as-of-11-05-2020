({
	doInit : function(component, event, helper) {
		helper.initializeDataTable(component, event, helper);
        var sourceObject = component.get("v.sourceObj");
        var forSourceToSource = component.get("v.isSourceToSource");
        if(forSourceToSource){
            helper.initializeWarehouse(component, event, helper);
        }
        
        if(sourceObject == 'Supply'){
            if(forSourceToSource){
                component.set("v.header","Virgin");
            }else{
                component.set("v.header","Re-Use");
            }            
        }else if(sourceObject == 'Demand'){
            component.set("v.header","Re-Use");
        }
	},
    
    save : function(component, event, helper) {
        document.getElementById('errorMissing').innerHTML='';   
        //var allocataionType = component.get("v.sourceObj");
        var supplyId = component.get("v.supplyId");
        var demandId = component.get("v.demandId");
        //alert("demandId:"+demandId);
        //return;
        var totalQty = component.get("v.avlQuantity");
        var enterQty = component.find("enteredQty").get("v.value");
        var warehouseSupplyId = component.get("v.selectedWarehouse");        
        
        //alert("enterQty:"+enterQty+"\n"+"totalQty:"+totalQty);
        //return;
                
        if(enterQty == null || enterQty == ""){
            document.getElementById('errorMissing').innerHTML='Please enter Quantity!';
            return;
        }
        if(enterQty > totalQty){
            document.getElementById('errorMissing').innerHTML='Entered Quantity should not be more than Supply Quantity';
            return;
        }
        
        var isSourceToSource = component.get("v.isSourceToSource");
        if(isSourceToSource){            
            if(warehouseSupplyId == ""){
                document.getElementById('errorMissing').innerHTML='Select Warehouse!';
                return;
            }
        }

        helper.saveAllocation(component, event, helper, enterQty, supplyId, demandId, warehouseSupplyId);
	},
    
    Cancel : function(component, event, helper) {
        //window.history.go(-1);
        //return false;
        var modalEvent = component.getEvent("modalCommunication");        
        modalEvent.fire();
    },
    
    handleWarehouseSelection : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++){
            component.set("v.selectedWarehouse",selectedRows[i].Id);
            //alert(selectedRows[i].Id);
        }
    },
    
    handleModalCommunicationEvt : function(component, event, helper) {
        
        /*
         * alert("supplyId:"+event.getParam("supplyId")+"\n"+
              "retailer:"+event.getParam("retailer")+"\n"+
              "model:"+event.getParam("model")+"\n"+
              "color:"+event.getParam("color")+"\n"+
              "sizerPrint:"+event.getParam("sizerPrint")+"\n"+
              "warehouse:"+event.getParam("warehouse")+"\n"
             );
             */
        
        component.set("v.supplyId",event.getParam("supplyId"));
        component.set("v.retailer",event.getParam("retailer"));
        component.set("v.model",event.getParam("model"));
        component.set("v.color",event.getParam("color"));
        component.set("v.sizerPrint",event.getParam("sizerPrint"));
        component.set("v.warehouse",event.getParam("warehouse"));
    }
    
})