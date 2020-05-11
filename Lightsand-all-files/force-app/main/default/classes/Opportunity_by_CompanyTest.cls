/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class Opportunity_by_CompanyTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the Opportunity_by_CompanyTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        RollupService.testHandler(new Opportunity_by_Company__c());
    }
}