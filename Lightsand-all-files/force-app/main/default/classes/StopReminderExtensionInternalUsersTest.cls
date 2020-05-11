@isTest
public class StopReminderExtensionInternalUsersTest{
     @IsTest(SeeAllData=true) public static void testSubmitPageInternalUsersTest() {
        Online_Enquiry__c onlineEnquiry = [select Enquiry_Date__c from Online_Enquiry__c limit 1];
        //system.currentPageReference().getParameters().put('id', 'a0fN0000003uJQz');//sandbox
        system.currentPageReference().getParameters().put('id', 'a0f9000000IS7Dp');//production
        ApexPages.StandardController stdController = new ApexPages.StandardController(onlineEnquiry);
        StopReminderExtensionInternalUsers  ext = new StopReminderExtensionInternalUsers (stdController);
        ext.init();
    }
}