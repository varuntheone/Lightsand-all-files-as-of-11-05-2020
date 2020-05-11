trigger LockEnquiryRelatedDetails on Online_Enquiry__c (after update) {
    String oldRecordTypeId = '';
    String oldRecordStatus = '';
    String newRecordTypeId = '';
    String newRecordStatus = '';
    String newRecordId = '';
    for(Online_Enquiry__c oldOnlineEnquiry : Trigger.old){
        oldRecordTypeId = oldOnlineEnquiry.RecordTypeId;
        oldRecordStatus = oldOnlineEnquiry.Enquiry_Status__c;
    }
    for(Online_Enquiry__c newOnlineEnquiry : Trigger.new){
        newRecordTypeId = newOnlineEnquiry.RecordTypeId;
        newRecordStatus = newOnlineEnquiry.Enquiry_Status__c;
        newRecordId = newOnlineEnquiry.Id;
    }
    System.debug('##OldRecordTypeId--->'+oldRecordTypeId);
    System.debug('##NewRecordTypeId--->'+newRecordTypeId);
     System.debug('##OldRecordStatus--->'+oldRecordStatus);
    System.debug('##NewRecordStatus--->'+newRecordStatus);
    Map<String,String> enquiryRecordTypes = new Map<String,String>{};
            List<RecordType> rtypesenq = [Select Name, Id From RecordType where sObjectType='Online_Enquiry__c' and isActive=true];
            for(RecordType rt: rtypesenq){
                enquiryRecordTypes.put(rt.Name,rt.Id);
            }
     Map<String,String> detailRecordTypes = new Map<String,String>{};
     List<RecordType> rtypesdet = [Select Name, Id From RecordType where sObjectType='Online_Detail__c' and isActive=true];
     for(RecordType rt: rtypesdet){
                detailRecordTypes.put(rt.Name,rt.Id);
            }
    System.debug('##rtypesenq--->'+rtypesenq);
    System.debug('##detailRecordTypes--->'+detailRecordTypes);
    String enquiryLockRecordTypId = enquiryRecordTypes.get('Order -Locked');
    System.debug('##enquiryLockRecordTypId-->'+enquiryLockRecordTypId);
    String detailLockRecordTypId = detailRecordTypes.get('Locked Order');
    if(oldRecordTypeId!=null && newRecordTypeId!=null && oldRecordTypeId!=enquiryLockRecordTypId && newRecordTypeId==enquiryLockRecordTypId){
        System.debug('Now Change Detail Record status');
        List<Online_Detail__c> onlineDetails = [select RecordTypeId, Name from Online_Detail__c where TransactionID__c=:newRecordId];
        System.debug('##These detail records will be locked--->'+onlineDetails);
        if(onlineDetails!=null && onlineDetails.size()>0){
            for(Online_Detail__c eachOnlineDetail : onlineDetails){
                eachOnlineDetail.RecordTypeId = detailLockRecordTypId;
            }
            update onlineDetails;
        }
    }
}