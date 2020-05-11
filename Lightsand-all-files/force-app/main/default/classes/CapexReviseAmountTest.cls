@isTest
public with sharing class CapexReviseAmountTest {

    static testMethod void test_main() {
        CapexGenerator capexGen = new CapexGenerator();
        Capex__c testCapex = capexGen.generateOtherCapex();
        testCapex.Capex_Approval_Status__c = CapexReviseAmountController.ALLOW_CHANGE_STATUS;
        testCapex.COO_Approved_Date__c = System.today().addDays((-1 * CapexReviseAmountController.ALLOW_CHANGE_APPROVAL_DURATION) - 2);
        insert testCapex;
        
        Test.startTest();
        
        PageReference testPage = Page.CapexReviseAmountPage;
        ApexPages.StandardController stdController = new ApexPages.StandardController(testCapex);
        Test.setCurrentPageReference(testPage);
        CapexReviseAmountController testController = new CapexReviseAmountController(stdController);
        PageReference initRedirectPage = testController.initPage();
        
        // Cannot revise the Capex approved for more than (ALLOW_CHANGE_APPROVAL_DURATION) days
        System.assertEquals(null, initRedirectPage);
        
        testCapex.COO_Approved_Date__c = System.today();
        update testCapex;
        
        testPage = Page.CapexReviseAmountPage;
        stdController = new ApexPages.StandardController(testCapex);
        Test.setCurrentPageReference(testPage);
        testController = new CapexReviseAmountController(stdController);
        initRedirectPage = testController.initPage();
        
        testCapex = [SELECT Id, Capex_Approval_Status__c FROM Capex__c WHERE Id = :testCapex.Id];
        
        System.assertEquals(CapexReviseAmountController.CHANGE_TO_STATUS, testCapex.Capex_Approval_Status__c);
        System.assert(null != initRedirectPage);
        
        // Cannot click again
        stdController = new ApexPages.StandardController(testCapex);
        testController = new CapexReviseAmountController(stdController);
        initRedirectPage = testController.initPage();
        
        System.assertEquals(null, initRedirectPage);
        
        Test.stopTest();
    }
}