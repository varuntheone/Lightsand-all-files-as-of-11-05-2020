/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger Opportunity_Item_MasterTrigger on Opportunity_Item_Master__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    RollupService.triggerHandler(Opportunity_Item_Master__c.SObjectType);
}