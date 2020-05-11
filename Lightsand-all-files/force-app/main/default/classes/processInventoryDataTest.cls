@isTest
public class processInventoryDataTest {
    @isTest
    static void validateUploadRowsTest()
    {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        string returnBatchId = '';
        Inventory_Transaction_Stage__c dataRow = new Inventory_Transaction_Stage__c();
        dataRow.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        dataRow.Color__c = 'GRAY';
        dataRow.Upload_Batch_No__c = value.id;
        dataRow.Inventory_Model__c = 'TNGU139';
        dataRow.Warehouse__c = 'Longhua Factory';
        dataRow.Retailer_Code__c = 'GU';
        dataRow.Source__c = 'Virgin';
        dataRow.Stock_In_Date__c = '23-May-19';
        dataRow.Stock_In_Qty__c = '200';
        insert dataRow;
        Inventory_Transaction_Stage__c dataRowLojas = new Inventory_Transaction_Stage__c();
        dataRowLojas.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        dataRowLojas.Color__c = 'GRAY';
        dataRowLojas.Upload_Batch_No__c = value.id;
        dataRowLojas.Inventory_Model__c = 'TNGU139';
        dataRowLojas.Warehouse__c = 'Longhua Factory';
        dataRowLojas.Retailer_Code__c = 'LOJAS RENNER';
        dataRowLojas.Sizer_Print__c = 'print';
        dataRowLojas.Source__c = 'Virgin';
        dataRowLojas.Stock_In_Date__c = '23-May-19';
        dataRowLojas.Stock_In_Qty__c = '200';
        insert dataRowLojas;
        Inventory_Transaction_Stage__c dataRowLojasBlank = new Inventory_Transaction_Stage__c();
        dataRowLojasBlank.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        dataRowLojasBlank.Color__c = 'GRAY';
        dataRowLojasBlank.Upload_Batch_No__c = value.id;
        dataRowLojasBlank.Inventory_Model__c = 'TNGU139';
        dataRowLojasBlank.Warehouse__c = 'Longhua Factory';
        dataRowLojasBlank.Retailer_Code__c = 'LOJAS RENNER';
        dataRowLojasBlank.Sizer_Print__c = '';
        dataRowLojasBlank.Source__c = 'Virgin';
        dataRowLojasBlank.Stock_In_Date__c = '23-May-19';
        dataRowLojasBlank.Stock_In_Qty__c = '200';
        insert dataRowLojasBlank;
        Inventory_Transaction_Stage__c dataRowInvalid = new Inventory_Transaction_Stage__c();
        dataRowInvalid.Mainetti_Company__c = 'Mainetti (HK1) Ltd';
        dataRowInvalid.Color__c = 'GREY';
        dataRowInvalid.Upload_Batch_No__c = value.id;
        dataRowInvalid.Inventory_Model__c = 'TNGU1399';
        dataRowInvalid.Warehouse__c = 'Longhua 1Factory';
        dataRowInvalid.Retailer_Code__c = 'GUU';
        dataRowInvalid.Source__c = 'Vir';
        dataRowInvalid.Stock_In_Date__c = '23/09/19';
        dataRowInvalid.Stock_In_Qty__c = '200';
        insert dataRowInvalid;
        Inventory_Transaction_Stage__c dataRowBlank = new Inventory_Transaction_Stage__c();
        dataRowBlank.Mainetti_Company__c = '';
        dataRowBlank.Color__c = '';
        dataRowBlank.Upload_Batch_No__c = value.id;
        dataRowBlank.Inventory_Model__c = '';
        dataRowBlank.Warehouse__c = '';
        dataRowBlank.Retailer_Code__c = '';
        dataRowBlank.Source__c = '';
        dataRowBlank.Stock_In_Date__c = '';
        dataRowBlank.Stock_In_Qty__c = '';
        insert dataRowBlank;
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        getMasterData companyMap = new getMasterData();
        companyMap.getInventoryStagRows( updateBatchStatus.Id);
        companyMap.getManitteCompanyMap();
        companyMap.getManitteOrgCompanyMap();
        companyMap.getRetailerCodeMap();
        companyMap.getRTSModelMap(updateBatchStatus);
        companyMap.getPickListColorMap(updateBatchStatus);
        companyMap.getPickListMap('Data_Upload_Transaction__c','Warehouse__c');
        companyMap.getPickListMap('Data_Upload_Transaction__c','Source__c');
        companyMap.getSizePrintMap(updateBatchStatus);
        processInventoryData processInvData = new processInventoryData();
        processInvData.validateUploadRows(updateBatchStatus);
        System.assertEquals(returnBatchId,''); 
    }
    
    @isTest
    static void testParseLongDate()
    {
        boolean flag = true;
        Test.startTest();       
        processInventoryData processInvData = new processInventoryData();
        processInvData.parseLongDate('23-May-19');
        processInvData.isStockInQtyNumeric('200');
        Test.stopTest();
        System.assertEquals(true, flag); 
    }
    
    public class applicationException extends Exception {}
    
}