@isTest
public class SubmitPageExtensionInternalUsersTest{
     @IsTest(SeeAllData=true) public static void testSubmitPageInternalUsersTest() {
        Online_Enquiry__c enq = [select Enquiry_Date__c from Online_Enquiry__c limit 1];
        List<Online_Detail__c> newlist = [select id from Online_Detail__c limit 2];
        system.currentPageReference().getParameters().put('id', enq.id);
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(newlist);
        SubmitPageExtensionInternalUsers  ext = new SubmitPageExtensionInternalUsers (stdController);
        ext.init();
    }
}