@isTest
public class processMaterialDataTest {    
    @isTest
    static void validateUploadRowsTest()
    {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Material Pricing';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        string returnBatchId = '';
        MaterialPricing_Transaction_Stage__c dataRow = new MaterialPricing_Transaction_Stage__c();
        dataRow.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        dataRow.Upload_Batch_No__c = value.id;
        dataRow.Location__c = 'usa';
        dataRow.Material_Type__c = 'lenin';
        dataRow.Unit_Price__c = '100';
        dataRow.UOM__c = '10';
        dataRow.Year__c = '2019';
        dataRow.Month__c = '10';
        dataRow.Date__c = '10';
        insert dataRow;
        MaterialPricing_Transaction_Stage__c dataRowBlank = new MaterialPricing_Transaction_Stage__c();
        dataRowBlank.Mainetti_Company__c = '';
        dataRowBlank.Upload_Batch_No__c = value.id;
        dataRowBlank.Location__c = '';
        dataRowBlank.Material_Type__c = '';
        dataRowBlank.Unit_Price__c = '';
        dataRowBlank.UOM__c = '';
        dataRowBlank.Year__c = '';
        dataRowBlank.Month__c = '';
        dataRowBlank.Date__c = '';
        insert dataRow;
        MaterialPricing_Transaction_Stage__c dataRowInvalid = new MaterialPricing_Transaction_Stage__c();
        dataRowInvalid.Mainetti_Company__c = 'Mainetti (HK1) Ltd';
        dataRowInvalid.Upload_Batch_No__c = value.id;
        dataRowInvalid.Location__c = 'usa';
        dataRowInvalid.Material_Type__c = 'lenin';
        dataRowInvalid.Unit_Price__c = '100';
        dataRowInvalid.UOM__c = '10';
        dataRowInvalid.Year__c = '2019';
        dataRowInvalid.Month__c = '10';
        dataRowInvalid.Date__c = '10';
        insert dataRowInvalid;
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        getMasterData companyMap = new getMasterData();
        companyMap.getInventoryStagRows( updateBatchStatus.Id);
        companyMap.getManitteCompanyMap();
        companyMap.getManitteOrgCompanyMap();

        processInventoryData processInvData = new processInventoryData();
        processInvData.validateUploadRows(updateBatchStatus);
        System.assertEquals(returnBatchId,''); 
    }

}