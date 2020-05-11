@isTest
public class SubmitQuoteExtensionInternalUsersTest{
     @IsTest(SeeAllData=true) public static void testSubmitPageInternalUsersTest() {
        Online_Enquiry__c enq = [select Enquiry_Date__c from Online_Enquiry__c limit 1];
        List<Online_Detail__c> newlist = [select id from Online_Detail__c limit 1];
        
        //det.TransactionID__c = 'a0fN0000003uJQz';
        //List<Online_Detail__c> newlist = new List<Online_Detail__c>();
        //newlist.add(det);
        system.currentPageReference().getParameters().put('id', enq.id);
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(newlist);
        SubmitQuoteExtensionInternalUsers  ext = new SubmitQuoteExtensionInternalUsers (stdController);
        ext.init();
    }
}