@isTest
private class CapexApprovalVoidTest {

    static testMethod void test_main() {
        CapexGenerator capexGen = new CapexGenerator();
        Capex__c testCapex = capexGen.generateOtherCapex();
        testCapex.Capex_Approval_Status__c = CapexApprovalVoidController.ALLOW_CHANGE_STATUS;
        insert testCapex;
        
        Test.startTest();
        
        PageReference testPage = Page.CapexApprovalVoidPage;
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCapex);
        Test.setCurrentPageReference(testPage);
        CapexApprovalVoidController testController = new CapexApprovalVoidController(stdController);
        PageReference initRedirectPage = testController.initPage();
        
        testCapex = [SELECT Id, Capex_Approval_Status__c FROM Capex__c WHERE Id = :testCapex.Id];
        
        System.assertEquals(CapexApprovalVoidController.CHANGE_TO_STATUS, testCapex.Capex_Approval_Status__c);
        System.assert(null != initRedirectPage);
        
        // Cannot click again
        stdController = new ApexPages.StandardController(testCapex);
        testController = new CapexApprovalVoidController(stdController);
        initRedirectPage = testController.initPage();
        
        System.assertEquals(null, initRedirectPage);
        
        Test.stopTest();
    }
}