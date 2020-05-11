@IsTest public class InsertRetailerCodeTest{

    @IsTest(SeeAllData=true) public static void testInsertRetailerCodeTriggerTest() {
        test.startTest();
        Online_Enquiry__c enq = new Online_Enquiry__c();
        enq.RecordTypeId = '01290000000TNpVAAW';
        insert enq;
        Online_Enquiry__c enq1 = new Online_Enquiry__c();
        enq1.RecordTypeId = '01290000000TNpU';
        insert enq1;
        test.stopTest();
    }
}