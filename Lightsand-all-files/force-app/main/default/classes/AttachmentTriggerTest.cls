@isTest
private class AttachmentTriggerTest {

    static testMethod void test_Capex_updateFlag() {
        CapexGenerator capexGen = new CapexGenerator();
        AttachmentGenerator attachGen = new AttachmentGenerator();
        Capex__c testCapex = capexGen.generateOtherCapex();
        insert testCapex;
        
        Test.startTest();
        
        testCapex = [SELECT Id, Document_Attached__c FROM Capex__c WHERE Id = :testCapex.Id];
        System.assertEquals(false, testCapex.Document_Attached__c);
        
        Attachment testAttach = attachGen.generatePDFAttachment(testCapex.Id, 'Test File', 'Test File');
        insert testAttach;
        
        testCapex = [SELECT Id, Document_Attached__c FROM Capex__c WHERE Id = :testCapex.Id];
        System.assertEquals(true, testCapex.Document_Attached__c);
        
        delete testAttach;
        
        testCapex = [SELECT Id, Document_Attached__c FROM Capex__c WHERE Id = :testCapex.Id];
        System.assertEquals(false, testCapex.Document_Attached__c);
        
        Test.stopTest();
    }
}