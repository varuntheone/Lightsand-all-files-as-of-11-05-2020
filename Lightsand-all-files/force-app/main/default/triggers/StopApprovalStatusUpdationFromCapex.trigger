trigger StopApprovalStatusUpdationFromCapex on Capex__c (before update) {

    String oldApprovalStatusValue = '';
    String newApprovalStatusValue = '';
	String capexRecallStatusValue = '';
    
    for(Capex__c oldCapex : Trigger.old){
        oldApprovalStatusValue = oldCapex.Capex_Approval_Status__c;
     }
    for(Capex__c newCapex : Trigger.new){
        newApprovalStatusValue = newCapex.Capex_Approval_Status__c;
		capexRecallStatusValue = newCapex.Capex_Recall_Status__c;
         if(oldApprovalStatusValue=='Void' && (newApprovalStatusValue!='New Registration' || capexRecallStatusValue=='Pending Approval by Country Head')){
        System.debug('##Check if trigger is being called on Recall');
        newCapex.addError('You cannot Approve/Reject this Capex since it is a Void record');
        }
    }
    
}