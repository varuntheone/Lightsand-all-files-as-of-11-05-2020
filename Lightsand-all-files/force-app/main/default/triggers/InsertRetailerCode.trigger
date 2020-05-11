trigger InsertRetailerCode on Online_Enquiry__c (before insert) {
    if(Trigger.isBefore){
        for(Online_Enquiry__c onlineEnquiry : Trigger.new){
            //Create a map between the Record Type Name and Id for easy retrieval
            Map<String,String> enquiryRecordTypes = new Map<String,String>{};
            List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Online_Enquiry__c' and isActive=true];
            for(RecordType rt: rtypes){
                enquiryRecordTypes.put(rt.Name,rt.Id);
            }
            System.debug('##Retailer Codes--->'+enquiryRecordTypes);
            System.debug('##Record Type Id-->'+onlineEnquiry.RecordTypeId);
            System.debug('##Record Type Id from Map-->'+enquiryRecordTypes.get('JCP Order'));
            System.debug('##Retailer code to get is :'+onlineEnquiry.RecordTypeId==enquiryRecordTypes.get('JCP Order'));
            String retailerCodeIdFromMap = enquiryRecordTypes.get('JCP Order');
            System.debug('##Record Type Id from Map Str-->'+retailerCodeIdFromMap);
            if(onlineEnquiry!=null && onlineEnquiry.RecordTypeId==retailerCodeIdFromMap){
            if(onlineEnquiry.Retailer_Code__c==null){
                System.debug('##Updating retailercode in onlineenquiry');
                onlineEnquiry.Retailer_Code__c = 'a009000000fmkBv';
                }
            }else{
                System.debug('##OnlineEnquiry['+onlineEnquiry+'] onlineEnquiry.RecordTypeId['+onlineEnquiry.RecordTypeId+'] enquiryRecordTypes['+enquiryRecordTypes+']');
            }
        }
    }
}