@IsTest public class UpdateOnlineDetailWithProductDetailsTest{
    
    @IsTest(SeeAllData=true) public static void testUpdateOnlineDetailWithProductDetailsTriggerTest() {
        test.startTest();
        Online_Detail__c detail = new Online_Detail__c();
        detail.Model__c = 'a029000000Br378';
        detail.TransactionID__c = 'a0f900000050AvE';
        insert detail;
        test.stopTest();
    }

}