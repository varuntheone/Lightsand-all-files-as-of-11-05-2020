trigger AccountPostMappingTrigger on Account_Post_Mapping__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

	validateFields();

	/**
     * Validate the fields
     * Dependent Methods: N/A
     * Action to Fire: after insert, after update, after undelete
     **/
	private void validateFields() {
		if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate || trigger.isUnDelete)) {
			Map<String, CollaborationGroup> chatGroupNameToGroupMap = null;
			Map<ID, Account_Post_Mapping__c> oldAcctPostMapingMap = new Map<ID, Account_Post_Mapping__c>();
			if (trigger.isUpdate)
				oldAcctPostMapingMap = trigger.oldMap;
			for (Account_Post_Mapping__c acctPostMap : trigger.new) {
				if (trigger.isUnDelete
					|| trigger.isInsert
					|| oldAcctPostMapingMap.get(acctPostMap.Id).Chatter_Group_Name__c != acctPostMap.Chatter_Group_Name__c) {
					if (chatGroupNameToGroupMap == null) {
						// Initialize Chatter Group List
						chatGroupNameToGroupMap = new Map<String, CollaborationGroup>();
						List<CollaborationGroup> tempChatGroupList = [SELECT Id, Name FROM CollaborationGroup];
						for (CollaborationGroup tempChatGroup : tempChatGroupList) {
							chatGroupNameToGroupMap.put(tempChatGroup.Name, tempChatGroup);
						}
					}
					
					// Validate chatter group name
					if (chatGroupNameToGroupMap.get(acctPostMap.Chatter_Group_Name__c) == null) { // No this chatter group
						acctPostMap.Chatter_Group_Name__c.addError(String.format('Chatter group ({0}) is not found', new String[] {acctPostMap.Chatter_Group_Name__c}));
					}
				}
			}
		}
	}
}