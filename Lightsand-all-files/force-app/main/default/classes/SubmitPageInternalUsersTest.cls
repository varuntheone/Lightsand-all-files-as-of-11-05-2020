@isTest
public class SubmitPageInternalUsersTest{

     @IsTest(SeeAllData=true) public static void testSubmitPageInternalUsersTest() {
        Online_Detail__c det = new Online_Detail__c();
        det.TransactionID__c = 'a0f900000050AvE';
        List<Online_Detail__c> newlist = new List<Online_Detail__c>();
        newlist.add(det);
        system.currentPageReference().getParameters().put('id', 'a0f900000050AvE');
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(newlist);
        SubmitPageExtensionInternalUsers  ext = new SubmitPageExtensionInternalUsers (stdController);
        ext.init();
    }
}