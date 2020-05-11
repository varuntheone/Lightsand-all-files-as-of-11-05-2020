@isTest
private class AccountPostMappingTriggerTest {

    static testMethod void test_validateFields() {
    	final String testCGName_USA = 'Test Chatter Group - USA';
    	final String testCGName_UK = 'Test Chatter Group - UK';
    	ChatterGenerator chatGenerator = new ChatterGenerator();
    	CollaborationGroup chatterGroup_USA = chatGenerator.generateChatterGroup(testCGName_USA, true);
    	CollaborationGroup chatterGroup_UK = chatGenerator.generateChatterGroup(testCGName_UK, true);
        Account_Post_Mapping__c acctPostMapping = new Account_Post_Mapping__c(
        	Account_Record_Type__c = AccountGenerator.RTLabel_Retailer
        	, Account_Market_Segment__c = AccountGenerator.MSEGMENT_USA
        	, Chatter_Group_Name__c = testCGName_USA
        );
        
        Test.startTest();
        
        // Should Failed
        Boolean hasFailed = false;
        try {
        	insert acctPostMapping;
        } catch (DmlException dmle) {
        	hasFailed = true;
        }
        System.assertEquals(true, hasFailed);
        
    	insert chatterGroup_USA;
        insert acctPostMapping;
        
        acctPostMapping.Chatter_Group_Name__c = testCGName_UK;
        insert chatterGroup_UK;
        update acctPostMapping;
        
        Test.stopTest();
    }
}