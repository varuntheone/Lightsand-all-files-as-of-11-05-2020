@isTest
public class inventoryAdminAccessClassTest {
    
    @isTest
    static void testGetRetailerData()
    { 
        Inventory_Transaction_Stage__c inventoryTranscation = new Inventory_Transaction_Stage__c();
        inventoryTranscation.Retailer_Code__c= 'GU';
       	inventoryTranscation.Inventory_Model__c = 'TNGU134B';
        inventoryTranscation.Retailer_Check__c = true;
        inventoryTranscation.Model_Check__c = True;
       	inventoryTranscation.Record_Status__c = '2 - Data Validation Successful';
        inventoryTranscation.Upload_Batch_No__c = inventoryTranscation.Id;
        insert inventoryTranscation;
        Inventory_Transaction_Master__c inventoryTransMast = new Inventory_Transaction_Master__c();
        inventoryAdminAccessClass.getRetailerData(inventoryTranscation.Id);
        inventoryAdminAccessClass.getModelData(inventoryTranscation.Id);
        inventoryAdminAccessClass.recStatusUpsertForInventory(inventoryTranscation.Id);
        inventoryAdminAccessClass.recUpdateFOrInvSuccess(inventoryTransMast.Id);
        inventoryAdminAccessClass.recUpdateFOrInvFailure(inventoryTransMast.Id);
    }
    
}