trigger CapexTrigger on Capex__c (after insert, after update) {

	shareWithApprovers();

	/**
     * Create sharing rules for approvers which are specified in record
     * Dependent Methods: N/A
     * Action to Fire: after insert, after update
     **/
     private void shareWithApprovers() {
     	if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
     		final String ACCESS_LEVEL_ALL = 'All';
     		final String ACCESS_LEVEL_EDIT = 'Edit';
     		final String ACCESS_LEVEL_READ = 'Read';
     		final Map<String, String> APPROVER_FIELD_AND_ACCESS = new Map<String, String>{
     			'Country_Head_Sales_Director__c' => ACCESS_LEVEL_READ
     			, 'Global_Account_Manager__c' => ACCESS_LEVEL_READ
     			, 'Regional_Director_Deputy__c' => ACCESS_LEVEL_READ
     			, 'COO_Office__c' => ACCESS_LEVEL_EDIT
     		};
     		final List<String> ACCESS_LEVEL_COMPARE_LIST = new List<String>{ACCESS_LEVEL_ALL, ACCESS_LEVEL_EDIT, ACCESS_LEVEL_READ};
     		final String sharingReason = Schema.Capex__Share.RowCause.Capex_Approver__c;
     		List<Capex__Share> existingCapexShareList = null;
     		List<Capex__Share> insertCapexShareList = new List<Capex__Share>();
     		List<Capex__Share> deleteCapexShareList = new List<Capex__Share>();
     		Set<String> approverFields = APPROVER_FIELD_AND_ACCESS.keySet();
     		for (Capex__c capex : trigger.new) {
     			Boolean hasChange = false;
     			Set<ID> oldApproverIdSet = new Set<ID>(); // Used to avoid deleting the sharing rules created by manually
     			
     			if (trigger.isInsert) {
     				hasChange = true;
     			} else if (trigger.isUpdate) {
     				for (String approverField : approverFields) {
     					// Delete all existing sharing rules if any change on approver fields
	     				ID newApproverId = (ID)capex.get(approverField);
     					ID oldApproverId = (ID)trigger.oldMap.get(capex.Id).get(approverField);
	     				if (oldApproverId != null)
	     					oldApproverIdSet.add(oldApproverId);
     					if (oldApproverId != newApproverId) // approver changed
     						hasChange = true;
     				}
     			}
     			
     			if (hasChange) {
     				if (trigger.isUpdate) {
	     				// Delete sharing rule of old approvers
	 					if (existingCapexShareList == null)
	 						existingCapexShareList = [SELECT Id, ParentId, UserOrGroupId, RowCause FROM Capex__Share WHERE ParentId IN :trigger.new];
	 					for (Capex__Share tempCapexShare : existingCapexShareList) {
		 					if (tempCapexShare.ParentId == capex.Id && tempCapexShare.UserOrGroupId != capex.OwnerId
		 						&& oldApproverIdSet.contains(tempCapexShare.UserOrGroupId) && tempCapexShare.RowCause == sharingReason) {
		 						deleteCapexShareList.add(tempCapexShare);
		 					}
	 					}
     				}
     				// Start creating sharing rules
     				Set<ID> addedApproverIdSet = new Set<ID>(); // Used to avoid sharing rules having duplicate target user
     				for (String approverField : approverFields) {
     					ID newApproverId = (ID)capex.get(approverField);
     					
     					if (newApproverId != null && newApproverId != capex.OwnerId) { // Do not need sharing rule for record owner
     						String accessLevel = APPROVER_FIELD_AND_ACCESS.get(approverField);
     						if (addedApproverIdSet.contains(newApproverId)) { // if already have a sharing rule
     							// Remove old sharing rule if the new access level is greater
     							Integer countCS = 0;
     							for (Capex__Share tempInsertCapexShare : insertCapexShareList) {
     								if (tempInsertCapexShare.ParentId == newApproverId) {
     									for (String compareAccessLevel : ACCESS_LEVEL_COMPARE_LIST) {
     										if (accessLevel == compareAccessLevel) {
     											if (tempInsertCapexShare.AccessLevel != compareAccessLevel) {
     												insertCapexShareList.remove(countCS);
     												addedApproverIdSet.remove(newApproverId);
     											}
     											break;
     										}
     									}
     									break;
     								}
     								countCS++;
     							}
     						}
     						
	     					if (!addedApproverIdSet.contains(newApproverId)) {
		     					Capex__Share insertCapexShare = new Capex__Share(
		     						ParentId = capex.Id
		     						, UserOrGroupId = newApproverId
		     						, AccessLevel = accessLevel
		     						, RowCause = sharingReason
		     					);
		     					insertCapexShareList.add(insertCapexShare);
	     						addedApproverIdSet.add(newApproverId);
	     					}
     					}
     				}
     			}
     		}
     		// Start writing the changes to database
     		if (insertCapexShareList.size() > 0 || deleteCapexShareList.size() > 0) {
	     		System.Savepoint sp = database.setSavepoint();
	     		List<Capex__Share> dmlExRecordList = null;
	     		DmlException dmlEx = null;
	     		if (deleteCapexShareList.size() > 0 && dmlEx == null) {
	     			try {
	     				delete deleteCapexShareList;
	     			} catch (DmlException dmle) {
	     				database.rollback(sp);
	     				dmlEx = dmle;
	     				dmlExRecordList = deleteCapexShareList;
	     			}
	     		}
	     		if (insertCapexShareList.size() > 0 && dmlEx == null) {
	     			try {
	     				insert insertCapexShareList;
	     			} catch (DmlException dmle) {
	     				database.rollback(sp);
	     				dmlEx = dmle;
	     				dmlExRecordList = insertCapexShareList;
	     			}
	     		}
	     		// Handle error messages
	     		if (dmlEx != null) {
	     			Integer dmlSize = dmlEx.getNumDml();
	     			for (Integer i = 0; i < dmlSize; i++) {
	     				Capex__Share failedCapexShare = dmlExRecordList.get(dmlEx.getDmlIndex(i));
	     				Capex__c failedCapex = trigger.newMap.get(failedCapexShare.ParentId);
	     				if (failedCapex != null) {
	     					failedCapex.addError(dmlEx.getMessage());
	     					failedCapex.addError(dmlEx.getDmlMessage(i));
	     				}
	     			}
	     		}
     		}
     	}
     }

}