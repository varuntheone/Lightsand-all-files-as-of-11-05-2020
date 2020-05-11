trigger FeedItemTrigger on FeedItem (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

	copyAccountFeedToChatterGroup();

	/**
     * Copy the account's chatter posts to corresponding chatter group
     * Dependent Methods: N/A
     * Action to Fire: after insert
     **/
     private void copyAccountFeedToChatterGroup() {
     	if (trigger.isAfter && trigger.isInsert) {
     		Set<String> targetTypeSet = new Set<String> {
     			'TextPost'
     			, 'ContentPost'
     			, 'LinkPost'
     		};
     		String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
     		
     		// Find all feed items which are needed to be handled
     		List<FeedItem> needHandleFeedItemList = new List<FeedItem>();
     		Set<ID> feedAcctId = new Set<ID>();
     		for (FeedItem fi : trigger.new) {
     			if (targetTypeSet.contains(fi.Type) // is target handling types
     				&& ((String)fi.ParentId).startsWith(accountPrefix)) { // and parent is account
     				needHandleFeedItemList.add(fi);
     				feedAcctId.add(fi.ParentId);
     			}
     		}
     		
     		// get relevant records
     		List<Account_Post_Mapping__c> acctPostMappingList = null; // Account and Chatter Group mappings
     		Map<String, CollaborationGroup> chatterGroupNameToGroupMap = null; // chatter groups
     		Map<ID, Account> feedAcctMap = new Map<ID, Account>(); // accounts of feed items
     		if (needHandleFeedItemList.size() > 0) {
     			acctPostMappingList = [SELECT Account_Record_Type__c, Account_Market_Segment__c, Chatter_Group_Name__c FROM Account_Post_Mapping__c];
     			List<CollaborationGroup> allChatterGroup = [SELECT Id, Name FROM CollaborationGroup];
     			chatterGroupNameToGroupMap = new Map<String, CollaborationGroup>();
     			for (CollaborationGroup cg : allChatterGroup) {
     				chatterGroupNameToGroupMap.put(cg.Name, cg);
     			}
     		}
     		if (feedAcctId.size() > 0) {
     			feedAcctMap = new Map<ID, Account>([SELECT Id, RecordType.Name, Market_Segment__c, Name FROM Account WHERE Id IN :feedAcctId]);
     		}
     		
     		// start moving to chatter group
     		List<FeedItem> newFIList = new List<FeedItem>();
     		for (FeedItem fi : needHandleFeedItemList) {
     			// Find the target chatter group
     			Account fiAcct = feedAcctMap.get(fi.parentId);
     			String chatterGroupName = searchChatterGroupName(acctPostMappingList, fiAcct.RecordType.Name, fiAcct.Market_Segment__c);
     			if (chatterGroupName == null) { // do not need to copy
     				continue;
     			}
     			CollaborationGroup chatterGroup = chatterGroupNameToGroupMap.get(chatterGroupName);
     			if (chatterGroup == null) {
     				fi.addError(String.format('Chatter Group ({0}) is not found', new String[] {chatterGroupName}));
     				continue;
     			}
     			// Copy the feed item and move to chatter group
     			FeedItem newFI = copyFeedItem(fi, fiAcct.Name, fiAcct.Id);
     			newFI.ParentId = chatterGroup.Id;
     			newFIList.add(newFI);
     		}
     		if (newFIList.size() > 0) {
     			insert newFIList;
     		}
     	}
     }
     
     private FeedItem copyFeedItem(FeedItem origFI, String acctName, ID acctId) {
     	FeedItem newFI = null;
     	if (origFI.Type == 'ContentPost') { // if attachment
 			newFI = new FeedItem(
 				Type = 'LinkPost'
 				, Title = origFI.ContentFileName
 				, LinkUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + '/' + origFI.RelatedRecordId
 				, Body = origFI.Body
 			);
 		} else {
 			newFI = origFI.clone(false, true, false, false);
 		}
 		String origBodyText = newFI.Body == null ? '' : newFI.Body;
 		newFI.Body = String.format(Label.ChatterPostSourceMsg_Account, new String[] {acctName}) + '\n'
 						+ System.Url.getSalesforceBaseUrl().toExternalForm() + '/' + acctId + '\n\n'
 						+ origBodyText;
 		return newFI;
     }
     
     /*
     * search the chatter group name
     * Used By: copyAccountFeedToChatterGroup()
     */
     private String searchChatterGroupName(List<Account_Post_Mapping__c> acctPostMappingList, String rtName, String marketSegment) {
     	for (Account_Post_Mapping__c acctPostMap : acctPostMappingList) {
     		if (acctPostMap.Account_Record_Type__c == rtName
     			&& acctPostMap.Account_Market_Segment__c == marketSegment) {
     			return acctPostMap.Chatter_Group_Name__c;
     		}
     	}
     	return null;
     }
}