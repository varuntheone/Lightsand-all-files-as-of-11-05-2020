@IsTest public class LockEnquiryRelatedDetailsTest{
    
    @IsTest(SeeAllData=true) public static void testLockEnquiryRelatedDetailstTriggerTest() {
        test.startTest();
        Online_Enquiry__c enq = [select Id, RecordTypeId, Enquiry_Status__c from Online_Enquiry__c where Id='a0f900000050AvE'];
        enq.RecordTypeId = '01290000000TNpX';
        update enq;
        test.stopTest();
    }

}