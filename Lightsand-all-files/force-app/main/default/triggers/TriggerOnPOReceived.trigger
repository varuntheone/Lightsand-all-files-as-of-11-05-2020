trigger TriggerOnPOReceived on Attachment (after insert, after delete) {
    Boolean isAccountAttachment = FALSE;    
    List<Online_Enquiry__c> enquiries = new List<Online_Enquiry__c>();  
    Set<Id> listOfIds = new Set<Id>();  
    if(Trigger.isInsert){
        for(Attachment att:trigger.New){
            System.debug('Attachment Parent  = '+att.ParentId.getSobjectType());
            if(att.ParentId.getSobjectType()==Online_Enquiry__c.SobjectType && (!listOfIds.contains(att.ParentId))){
                System.debug('Enquiry Row Id  = '+att.ParentId);
                enquiries.add(
                    new Online_Enquiry__c(
                        Id=att.ParentId,
                        flag_POC_received__c=true
                        //Enquiry_Status__c = 'PO Received'
                    )
                );  
                //add the Enquiry Id in set to eliminate dupe updates
                listOfIds.add(att.ParentId);  
            }
		}
    }else if(Trigger.isDelete){
        for(Attachment att:trigger.Old){
            System.debug('Attachment Parent  = '+att.ParentId.getSobjectType());
            if(att.ParentId.getSobjectType()==Online_Enquiry__c.SobjectType && (!listOfIds.contains(att.ParentId))){
                System.debug('Enquiry Row Id  = '+att.ParentId);
                enquiries.add(
                    new Online_Enquiry__c(
                        Id=att.ParentId,
                        flag_POC_received__c=false
                        //Enquiry_Status__c = 'PO Received'
                    )
                );  
                //add the Enquiry Id in set to eliminate dupe updates
                listOfIds.add(att.ParentId);  
            }
		}
    }
    //finally update accounts  
    update enquiries; 
}