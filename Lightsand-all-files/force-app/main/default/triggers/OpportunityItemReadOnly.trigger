trigger OpportunityItemReadOnly on Opportunity_Item_Master__c (before update) {
     String errorMsg='Insufficient access rights to Edit this Record';
    for(Opportunity_Item_Master__c oim : trigger.new){
        List<UserRecordAccess> usr =[SELECT RecordId FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND HasEditAccess = True AND RecordId =: oim.Opportunity_ID__c];
        if( usr.size() == 0 ){
            oim.addError(errorMsg,false); 
        }               
    }     
}