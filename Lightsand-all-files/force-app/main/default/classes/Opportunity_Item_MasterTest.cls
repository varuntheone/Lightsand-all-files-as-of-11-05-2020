/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class Opportunity_Item_MasterTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the Opportunity_Item_MasterTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        RollupService.testHandler(new Opportunity_Item_Master__c());
    }
}