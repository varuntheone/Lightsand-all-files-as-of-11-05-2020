/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger Opportunity_by_CompanyTrigger on Opportunity_by_Company__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    RollupService.triggerHandler(Opportunity_by_Company__c.SObjectType);
}