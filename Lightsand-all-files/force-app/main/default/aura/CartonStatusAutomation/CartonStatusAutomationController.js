({
	checkCartonStatus : function(component, event, helper) {
        helper.getLoginUserInformation(component, event, helper);
		var recordId = component.get("v.recordId");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        //alert('----int-->');
        var action = component.get("c.getcartonRecordData");
        action.setParams({
            "recId" :recordId            
        });    
        action.setCallback(this, function(response) {
            var state = response.getState(); 
             //alert('----state-->'+state);
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue(); 
                var AsiaCartonsStoreProfile = $A.get("$Label.c.RTS_Store_user_Profile_Name"); 
                var EuropeCartonsStoreProfile = $A.get("$Label.c.UK_RTS_Store_user");
                var ukcartoninternalUserProfile = $A.get("$Label.c.UK_RTS_Mainetti_Internal_Re_Active_User");
                
                var userProfileName = component.get("v.profileName");
                if($A.util.isUndefinedOrNull(stringItems.Store_User__c) && (AsiaCartonsStoreProfile === userProfileName || EuropeCartonsStoreProfile === userProfileName)){
                    helper.showToast(component, event,"Warning","Warning!",'Please select Store ID.');                  
                    if((stringItems.Status__c === 'Customer Warehouse' &&  AsiaCartonsStoreProfile === userProfileName ) || (stringItems.Status__c === 'Active' &&  EuropeCartonsStoreProfile === userProfileName )){
                    	helper.editRecordpage(component, event, helper);                       
                    }else{
                        helper.updateCartonStatusAutomation(component, event, helper); 
                    }
                }else{ 
                    //alert('hi'+userProfileName+'<------>'+ukcartoninternalUserProfile);
                    if(userProfileName === ukcartoninternalUserProfile && $A.util.isUndefinedOrNull(stringItems.Filled_Box_Weight__c)){
                        helper.editRecordpage(component, event, helper); 
                    }else{
                        helper.updateCartonStatusAutomation(component, event, helper); 
                    }
                   
                }
            }           
        });     
        $A.enqueueAction(action);
        
	},
  
})