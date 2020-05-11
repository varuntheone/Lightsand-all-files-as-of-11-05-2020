({
    doInit : function(component, event, helper) {
        helper.getAllRecordsfromDB(component, event, helper);
        helper.getCartonsofCurrentTransferNote(component, event, helper);
        helper.getTransferNoteInformation(component, event, helper);
    },
    
    handleKeySearchcartons: function(component, event, helper) {
        var SearchName = component.find('enter-search').get('v.value');
        if (SearchName.length > 0){
            SearchName = SearchName.toLowerCase();
            var getAllCatons = component.get("v.duplicateCartonsList");       
            var searchedCartonsList = [];
            for(var i = 0; i < getAllCatons.length; i++) {
                let cartname = getAllCatons[i].Name.toLowerCase();
                if(cartname.includes(SearchName)){                    
                    searchedCartonsList.push(getAllCatons[i]);
                }
            }
            component.set("v.cartonsList",searchedCartonsList);            
        }else{
            component.set("v.cartonsList",component.get("v.duplicateCartonsList"));
        }
    },
    
    handleSelectAllCartons: function(component, event, helper) {
        var getID = component.get("v.cartonsList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkCarton = component.find("checkCarton"); 
        
        if(!$A.util.isUndefinedOrNull(checkCarton.length)){
            if(checkvalue == true){                
                for(var i=0; i<checkCarton.length; i++){
                    checkCarton[i].set("v.value",true);
                }
            }
            else{ 
                for(var i=0; i<checkCarton.length; i++){
                    checkCarton[i].set("v.value",false);
                }
            }            
        }else{            
            checkCarton.set("v.value",true);
            //helper.showToast(component, event,'warning','warinig!','One Record selection not allowed.');
        }        
    },
    
    //Process the selected contacts
    handleSelectedCartons: function(component, event, helper) {
        var selectedCartons = [];
        var checkvalue = component.find("checkCarton");
        
        if(!$A.util.isUndefinedOrNull(checkvalue)){
            if(!Array.isArray(checkvalue)){
                if (checkvalue.get("v.value") == true) {
                    selectedCartons.push(checkvalue.get("v.text"));
                }
            }else{
                for (var i = 0; i < checkvalue.length; i++) {
                    if (checkvalue[i].get("v.value") == true) {
                        selectedCartons.push(checkvalue[i].get("v.text"));
                    }
                }
            }
            helper.cartonTagingTransferNote(component, event, helper,selectedCartons);
        }else{            
            helper.showToast(component, event,'warning','warinig!','Operation not allowed.');
        }
        //alert('selectedCartons-' + selectedCartons);
    },
    
    RemoveAllCartons: function(component, event, helper) {        
        var checkvalue = component.find("selectAllTF").get("v.value");        
        var checkCartons = component.find("checkcartontfnote"); 
        if(!$A.util.isUndefinedOrNull(checkCartons.length)){
            if(checkvalue == true){
                for(var i=0; i<checkCartons.length; i++){
                    checkCartons[i].set("v.value",true);
                }
            }
            else{ 
                for(var i=0; i<checkCartons.length; i++){
                    checkCartons[i].set("v.value",false);
                }
            }
        }else{
            checkCartons.set("v.value",true);
            //helper.showToast(component, event,'warning','warinig!','One Record selection not allowed.');
        } 
        
    },
    
    RemoveSelectedCartons: function(component, event, helper) {
        var selectedCartons = [];
        var checkvalue = component.find("checkcartontfnote");
        if(!$A.util.isUndefinedOrNull(checkvalue)){
            if(!Array.isArray(checkvalue)){
                if (checkvalue.get("v.value") == true) {
                    selectedCartons.push(checkvalue.get("v.text"));
                }
            }else{
                for (var i = 0; i < checkvalue.length; i++) {
                    if (checkvalue[i].get("v.value") == true) {
                        selectedCartons.push(checkvalue[i].get("v.text"));
                    }
                }
            }
            helper.cartonRemovefromTransferNote(component, event, helper,selectedCartons);
        }else{            
            helper.showToast(component, event,'warning','warinig!','Operation not allowed.');
        }
        //alert('selectedCartons-' + selectedCartons);
    },
    
    closePopUp : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        dismissActionPanel.fire();  
        $A.get('e.force:refreshView').fire();
    },
    
})