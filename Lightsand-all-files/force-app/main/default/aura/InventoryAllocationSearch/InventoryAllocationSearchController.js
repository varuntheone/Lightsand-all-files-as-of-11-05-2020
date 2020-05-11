({
    
  openModal: function(component, event, helper) {
      var SourceType = component.get("v.SourceType");
        //alert(SourceType);
        var modal = component.find("addRetailerModal");
         helper.getWarehousePicklist(component, event);   
},
    
    
    //Custom Lookup Retailerdata Controllers     
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
         $A.util.addClass(forclose, 'slds-is-close');
         $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfProductSearchRecords", null );
        var forclose = component.find("searchProductRes");
         $A.util.addClass(forclose, 'slds-is-close');
         $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfMainettiSearchRecords", null );
        var forclose = component.find("searchMainettiRes");
         $A.util.addClass(forclose, 'slds-is-close');
         $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfRtsSearchRecords", null );
        var forclose = component.find("searchRtsRes");
         $A.util.addClass(forclose, 'slds-is-close');
         $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    
    keyPressController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    
    keyPressProductController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchProductKeyWord"); 
        if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchProductRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchProductHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfProductSearchRecords", null ); 
            var forclose = component.find("searchProductRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    
    keyPressRtsController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchRtsKeyWord");
       if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchRtsRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchRtsHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfRtsSearchRecords", null ); 
            var forclose = component.find("searchRtsRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    
    keyPressMainettiController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchMainettiKeyWord");
       if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchMainettiRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchMainettiHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfMainettiSearchRecords", null ); 
            var forclose = component.find("searchMainettiRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    

    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONENT event 	 

        var selectedrecordByEvent = event.getParam("recordRetailerByEvent");
        if(selectedrecordByEvent != null && selectedrecordByEvent != ""){            
            component.set("v.selectedRetailerRecord" , selectedrecordByEvent);
            
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        }
        
        var selectedrecordByEvent = event.getParam("recordProductByEvent");
        if(selectedrecordByEvent != null && selectedrecordByEvent != ""){                        
            component.set("v.selectedProductRecord" , selectedrecordByEvent);
            
            var forclose = component.find("lookupProduct-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchProductRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupProductField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        }
        
        var selectedrecordByEvent = event.getParam("recordRtsByEvent");
        if(selectedrecordByEvent != null && selectedrecordByEvent != ""){            
            component.set("v.selectedRtsRecord" , selectedrecordByEvent);
            
            var forclose = component.find("lookupRts-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchRtsRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupRtsField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        }
        
        var selectedrecordByEvent = event.getParam("recordMainettiByEvent");
        if(selectedrecordByEvent != null && selectedrecordByEvent != ""){            
            component.set("v.selectedMainettiRecord" , selectedrecordByEvent);
            
            var forclose = component.find("lookupMainetti-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchMainettiRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupMainettiField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        }
     },
    
        // function to clear the selected retailer 
    clear :function(component,event,helper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRetailerRecord", {} );   
    },
    
        // function to clear the selected Product 
    clearProduct :function(component,event,helper){
        var pillTarget = component.find("lookupProduct-pill");
        var lookUpTarget = component.find("lookupProductField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchProductKeyWord",null);
        component.set("v.listOfProductSearchRecords", null );
        component.set("v.selectedProductRecord", {} );   
    },
    
         // function to clear the selected Rts 
    clearRts :function(component,event,helper){
        var pillTarget = component.find("lookupRts-pill");
        var lookUpTarget = component.find("lookupRtsField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchRtsKeyWord",null);
        component.set("v.listOfRtsSearchRecords", null );
        component.set("v.selectedRtsRecord", {} );   
    },
    
         // function to clear the selected Mainetti 
    clearMainetti :function(component,event,helper){
        var pillTarget = component.find("lookupMainetti-pill");
        var lookUpTarget = component.find("lookupMainettiField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchMainettiKeyWord",null);
        component.set("v.listOfMainettiSearchRecords", null );
        component.set("v.selectedMainettiRecord", {} );   
    },
    
    Search :function(component,event,helper){
        //alert("search1");
        var selCompany = component.get("v.selectedMainettiRecord.Default_Order_to_Company__c");
        var selRetailer = component.get("v.selectedRetailerRecord.Name");
        var selProduct = component.get("v.selectedProductRecord.Name");
        var selStartDate = component.find("strDate").get("v.value");        
        var selEndDate = component.find("enDate").get("v.value");
        //alert("before source");
        var sourceType = component.get("v.SourceType");
        var selSource;
        if(sourceType == "Supply"){
            selSource = component.get("v.selectedSource");
        }
        
        var selAllocation;
        if(sourceType == "Allocation"){
            selAllocation = component.get("v.selectedAllocation");
        }
        
        //alert("after source");
        var selware = component.get("v.ware.Name");
        var isCurrentWeekChecked = component.get("v.currWeekBoolean");
        var isShortFallPrdctsChecked = component.get("v.shortFallBoolean");
        
        
        /* alert("selCompany:"+selCompany+"\n"+
              "selRetailer:"+selRetailer+"\n"+
              "selProduct:"+selProduct+"\n"+
              "selStartDate:"+selStartDate+"\n"+
              "selEndDate:"+selEndDate+"\n"+
              "selSource:"+selSource+"\n"+
               "selware:"+selware+"\n"+
               "selAllocation:"+selAllocation+"\n"+
              "isCurrentWeekChecked:"+isCurrentWeekChecked+"\n"+
              "isShortFallPrdctsChecked:"+isShortFallPrdctsChecked+"\n");*/
              
              
        
        // call and fire the event   
        var compEvent = component.getEvent("searchCommunication");  
        compEvent.setParams({"company" : selCompany,
                             "retailer" : selRetailer,
                             "product" : selProduct,
                             "startDate" : selStartDate,
                             "endDate" : selEndDate,
                             "source" : selSource,
                             "allocationType" : selAllocation,
                             "warehouse" : selware,
                             "currentWeek" : isCurrentWeekChecked,
                             "shortfallProducts" : isShortFallPrdctsChecked
                            });    
        compEvent.fire();
        
        //var retailer = component.get("v.SearchKeyWord");
       // var product = component.get("v.SearchProductKeyWord");
        //var mainetti = component.get("v.SearchMainettiKeyWord");
         //if(retailer == null || retailer == "" ){
           // var text = 'Please Enter Search Values';
           // helper.selectErrorToast(component,event,helper,text);
            //return;
       // }  
   },
    
    //handleSourceEvent :function(component,event,helper){
        //alert("abc2");
        //component.set("v.source",event.getParam("SourceType"));
       // var selSourceType = component.get("v.source");
       // alert("selSource:"+selSourceType);
//},
    handleWarehouse : function(component, event, helper) {
        var Warehouse = component.get("v.ware.Name");
        //alert(Warehouse);
    },
    
    Sourceonchange : function(component, event, helper) {
        var  source = component.find("sourcePicklist").get("v.value");
        component.set("v.selectedSource",source);
    },
    
    Allocationonchange : function(component, event, helper) {
        var  allocationType = component.find("AllocationPicklist").get("v.value");
        component.set("v.selectedAllocation",allocationType);
    }
    
})