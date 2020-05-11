({
    doInit : function(component, event, helper) {
        component.set("v.noEmptyRecord",false);
        helper.initializeRetailer(component,helper);
        component.set("v.SearchKeyWord","");
        component.set("v.SearchUserKeyWord","");
        component.set("v.selectedUserRecord",[]);
    },
    
    addRetailer : function(component, event, helper) {
        document.getElementById('errorMissingSelected').innerHTML='';
        helper.openModal(component,helper);
    },
    
    addUser : function(component, event, helper) {
        document.getElementById('errorMissingSelected').innerHTML='';
        var retailer = component.get("v.SearchKeyWord");
        if(retailer == null || retailer == ""){
            var text = 'Please select Company';
            helper.selectErrorToast(component,event,helper,text);
            return;
        }
        //component.set("v.selectedRetailerRecord.Name",retailer);
        
        
        var actionRetailer = component.get("c.fetchRetailerId"); 
        actionRetailer.setParams({
            "mainettiName" : retailer
        });
        actionRetailer.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                for (var i = 0; i < result.length; i++) {
                    //alert(result[i].Name);
                    //alert(result[i].Id);
                    component.set("v.selectedRetailerRecord.Name",result[i].Name);
                	component.set("v.selectedRetailerRecord.Id",result[i].Id);
                }        
                //component.set("v.selectedRetailerRecord",result);
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);                
            }
        });
        $A.enqueueAction(actionRetailer);
        
        
        
        var action = component.get("c.getUsers"); 
        action.setParams({
            "mainettiName" : retailer
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var newList = [];
                for (var i = 0; i < result.length; i++) {
                    var row = result[i];
                    if (row.User__c) row.User__c = row.User__r.Name;
                    component.set("v.selectedUserRecord",result);
                }
                
             
                helper.openModal(component,helper);
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);                
            }
        });
        $A.enqueueAction(action); 

        //helper.openModal(component,helper);
    },
    
    deleteRetailer : function(component, event, helper) {
        var retailer = component.get("v.SearchKeyWord");        
        if(retailer == null || retailer == ""){
            var text = 'Please select Company to delete';
            helper.selectErrorToast(component,event,helper,text);
            return;
        }
        
        var action = component.get("c.deleteData"); 
        action.setParams({
            "mainettiName" : retailer
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    component.rerenderList();
                    var text = 'Company deleted successfully.';
                    helper.successToast(component,event,helper,text);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);                
            }
        });
        $A.enqueueAction(action); 
    },
    
    handleRemoveUserClick : function(component, event, helper) {
        var retailercode = event.getSource().get("v.value");
        var userName = event.getSource().get("v.name");
       /*alert('retailercode:'+retailercode+"\n"+
              'userName:'+userName);*/
        
        var action = component.get("c.deleteUser"); 
        action.setParams({
            "mainettiName" : retailercode,
            "userName" : userName
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    component.rerenderList();
                    var text = 'User deleted successfully.';
                    helper.successToast(component,event,helper,text);
                    component.rerenderList();
                    //window.location.reload();
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);                
            }
        });
        $A.enqueueAction(action); 
    },
    
    onRadioChange : function(component, event, helper) {
        //var selected = event.getSource().get("v.name");
        //var selected = document.getElementById("radioId").value;
        
        var redioChecked = document.getElementsByName('radioName');
        var radio_value;
        
        for(var i = 0; i < redioChecked.length; i++){            
            if(redioChecked[i].checked){                
                radio_value = redioChecked[i].value;
                //alert(radio_value);
                component.set("v.SearchKeyWord",radio_value);
            }            
        }
        
        //alert("selected:"+selected);
        //component.set("v.SearchKeyWord",selected);
    },
    
    Save: function(component, event, helper) {
        var retailer = component.get("v.selectedRetailerRecord");
        var userList = component.get("v.selectedUserRecord");
        
        if(Object.keys(retailer).length === 0){
            document.getElementById('errorMissingSelected').innerHTML='Please Select Company';
            return;
        }
        if(userList == "" || userList == null || userList.length == 0){
            document.getElementById('errorMissingSelected').innerHTML='Please Select users';
            return;
        }
        
        var action = component.get("c.saveData"); 
        action.setParams({
            "Partner" : retailer,
            "userList" : userList
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var status =response.getReturnValue();
                if(status){
                    component.rerenderList();
                    helper.clear(component,event,helper);
                    helper.closeModal(component, event, helper);
                    //component.set("v.selectedRetailerRecord","");
                    //component.set("v.selectedUserRecord","");
                    var text = 'Company saved successfully.';
                    helper.successToast(component,event,helper,text);
                }
            }else if(state === "ERROR") {
                var errors = response.getError();
                console.error(errors);                
            }
        });
        $A.enqueueAction(action);        
    },
    
    
    openModal: function(component, event, helper) {
        var modal = component.find("addRetailerModal");
        var modalBackdrop = component.find("addRetailerModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeModal: function(component, event, helper) {
        /*component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRetailerRecord",{});
        component.set("v.selectedUserRecord",{});*/
        helper.clear(component,event,helper);
        component.rerenderList();
        var modal = component.find("addRetailerModal");
        var modalBackdrop = component.find("addRetailerModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    
    //Custom Lookup Retailerdata Controllers     
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set("v.listOfUserSearchRecords", null );
        var forclose = component.find("searchUserRes");
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
    
    keyPressUserController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchUserKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){             
            var forOpen = component.find("searchUserRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchUserHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfUserSearchRecords", null ); 
            var forclose = component.find("searchUserRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function to clear the selected retailer 
    clear :function(component,event,heplper){
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
    
    // function to clear the selected user 
    clearUser :function(component,event,heplper){
        //var pillTarget = component.find("lookupUser-pill");
        //var lookUpTarget = component.find("lookupField"); 
        
        var userName = event.getSource().get("v.name");    
        var getSelectdUserList = component.get("v.selectedUserRecord");
        console.log("userName:"+userName.Name);
        //var newUserList = [];
        for(var i = 0; i < getSelectdUserList.length; i++){
            if(getSelectdUserList[i].Id == userName){
                getSelectdUserList.splice(i, 1);
                component.set("v.selectedUserRecord", getSelectdUserList);
            }  
        }
        /*for (var index = 0; index < getSelectdUserList.length; index++) {
            if(getSelectdUserList[index].Name != userName){
                newUserList.push(getSelectdUserList[index].Name);
                component.set("v.selectedUserRecord",newUserList);
                console.log("userName:"+getSelectdUserList[index].Name);
            }
        }*/
        //component.set("v.selectedUserRecord",newUserList);
        
        
        //$A.util.addClass(pillTarget, 'slds-hide');
        //$A.util.removeClass(pillTarget, 'slds-show');
        
        //$A.util.addClass(lookUpTarget, 'slds-show');
        //$A.util.removeClass(lookUpTarget, 'slds-hide');
        component.set("v.SearchUserKeyWord",null);
        component.set("v.listOfUserSearchRecords", null );  
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 

        var selectedrecordByEvent = event.getParam("recordByEvent");
       
        
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
         var selectedUserrecordByEvent = event.getParam("recordUserByEvent");
        if(selectedUserrecordByEvent != null && selectedUserrecordByEvent != ""){
            // populating the selected user list
            //var cmpMsg = component.find("msg");
            //$A.util.removeClass(cmpMsg, 'hide');
            //var oTextarea = component.find("oTextarea");
            //oTextarea.set("v.value", selectedUserrecordByEvent.Name);
            //alert(selectedUserrecordByEvent.Id);
            var pushToSelectdUser = component.get("v.selectedUserRecord")
            pushToSelectdUser.push(selectedUserrecordByEvent);
            component.set("v.selectedUserRecord" , pushToSelectdUser);
            var forclose = component.find("lookupUser-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchUserRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            /*var lookUpTarget = component.find("lookupUserField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');*/
        }
        
    },
})