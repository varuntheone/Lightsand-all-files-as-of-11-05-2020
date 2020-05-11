@isTest
private class FeedItemTriggerTest {

    static testMethod void test_copyAccountFeedToChatterGroup() {
        final String testCGName_USA = 'Test Chatter Group - USA';
    	final String testCGName_UK = 'Test Chatter Group - UK';
        AccountGenerator acctGenerator = new AccountGenerator();
    	ChatterGenerator chatGenerator = new ChatterGenerator();
    	CollaborationGroup chatterGroup_USA = chatGenerator.generateChatterGroup(testCGName_USA, true);
    	CollaborationGroup chatterGroup_UK = chatGenerator.generateChatterGroup(testCGName_UK, true);
    	
    	insert new CollaborationGroup[] {chatterGroup_USA, chatterGroup_UK};
    	
        Account_Post_Mapping__c acctPostMapping_USA = new Account_Post_Mapping__c(
        	Account_Record_Type__c = AccountGenerator.RTLabel_Retailer
        	, Account_Market_Segment__c = AccountGenerator.MSEGMENT_USA
        	, Chatter_Group_Name__c = testCGName_USA
        );
        Account_Post_Mapping__c acctPostMapping_UK = new Account_Post_Mapping__c(
        	Account_Record_Type__c = AccountGenerator.RTLabel_Retailer
        	, Account_Market_Segment__c = AccountGenerator.MSEGMENT_UK
        	, Chatter_Group_Name__c = testCGName_UK
        );
        
        insert new Account_Post_Mapping__c[] {acctPostMapping_USA, acctPostMapping_UK};
        
        Account acct_USA = acctGenerator.generateAccount(AccountGenerator.RTRetailer);
        Account acct_UK = acctGenerator.generateAccount(AccountGenerator.RTRetailer);
        acct_USA.Market_Segment__c = AccountGenerator.MSEGMENT_USA;
        acct_UK.Market_Segment__c = AccountGenerator.MSEGMENT_UK;
        
        insert new Account[] {acct_USA, acct_UK};
        
        Test.startTest();
        
        FeedItem post = chatGenerator.generatePost(acct_USA.Id, 'Test Post');
        insert post;
        List<FeedItem> result = [SELECT Id, Body FROM FeedItem WHERE ParentId = :chatterGroup_USA.Id AND Type = :post.Type];
        System.assertEquals(1, result.size());
        System.assert(result.get(0).Body.contains(post.Body));
        
        FeedItem link = chatGenerator.generateLinkPost(acct_UK.Id, 'http://www.mainetti.com/', 'Mainetti', 'Test Link');
        insert link;
        result = [SELECT Id, LinkUrl FROM FeedItem WHERE ParentId = :chatterGroup_UK.Id AND Type = :link.Type];
        System.assertEquals(1, result.size());
        System.assertEquals(link.LinkUrl, result.get(0).LinkUrl);
        
        FeedItem filePost = chatGenerator.generateContentPost(acct_USA.Id);
        insert filePost;
        filePost = [SELECT Id, ContentFileName, ContentData, Body, RelatedRecordId FROM FeedItem WHERE Id = :filePost.Id];
        String expectedLink = System.Url.getSalesforceBaseUrl().toExternalForm() + '/' + filePost.RelatedRecordId;
        result = [SELECT Id, LinkUrl FROM FeedItem WHERE ParentId = :chatterGroup_USA.Id AND Type = :ChatterGenerator.FI_TYPE_LINK_POST];
        System.assert(result.size() > 0);
        Boolean success = false;
        for (FeedItem fi : result) {
        	if (fi.LinkUrl == expectedLink)
        		success = true;
        }
        System.assert(success);
        
        Test.stopTest();
    }
}