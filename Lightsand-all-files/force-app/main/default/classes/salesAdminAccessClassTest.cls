@isTest
public class salesAdminAccessClassTest {
    
    @isTest
    static void testGetRetailerData()
    {
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus.Batch_Status__c = 'Migration In Progress';
        updateBatchStatus.Record_Type__c  = 'sales';
        insert updateBatchStatus;
        string returnBatchId = updateBatchStatus.Id;
        String batchId1 = updateBatchStatus.Id;
        
        Inventory_Transaction_Master__c invtrans = new Inventory_Transaction_Master__c();
        List<Sales_Transaction_Stage__c> transferRecords1 = new List<Sales_Transaction_Stage__c>();
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = invtrans.id;
        stageValue.Company__c = 'Hong Kong Packaging';
        stageValue.Year__c = '2019';
        stageValue.Unit_Sold__c = '234';
        stageValue.Unit_Price_100_EUR__c = '24';
        stageValue.Unit_Price_100_USD__c = '25';
        stageValue.Sales_EUR__c = '10';
        stageValue.Sales_USD__c = '20';
        stageValue.Unit_Sold__c = '234';
        stageValue.ExRate_to_EUR__c = '234';
        stageValue.ExRate_to_USD__c = '234';
        stageValue.Local_Net_Unit_Pirce_100__c = '234';
        stageValue.Sales_Transaction_Currency__c = '234';
        stageValue.Gross_Sales_USD__c = '12.2';
        stageValue.Freight_Charge_USD__c = '2.2';
        insert stageValue;
        
        List<Sales_Transaction_Stage__c> transferRecords= new List<Sales_Transaction_Stage__c>();
        transferRecords.add(stageValue);  
        
        
        string csv = '[{"Company__c":"Hong Kong Packaging","Year__c":"2019","Week__c":"Wk45","Month__c":"Jan","Item_code__c":"484","Material__c":"PP","Source__c":"Virgin","Model__c":"1000","Printed_Logo__c":"demoLogo","Color__c":"BLACK","Customer__c":"xxxxx","Customer_local_name__c":"xxxx","Mainetti_Brand__c":"Mainetti","Category__c":"HANGERS & ACCESSORIES","Sub_Category__c":"HANGERS","Family__c":"BOTTOM","Order_Type__c":"3rd","Unit_Sold__c":"8000","Unit_Price_100_EUR__c":"10.65123","Unit_Price_100_USD__c":"12.40602","Net_Unit_Price_100__c":"11","Sales_EUR__c":"2","Sales_USD__c":"5","Transaction_Currency__c":"HKD","ExRate_to_EUR__c":"9.08505","ExRate_to_USD__c":"7.8","Local_Net_Unit_Pirce_100__c":"13","Sales_Transaction_Currency__c":"2438.527291","Shipped_To_Factory__c":"xxxxxx","Shipped_To_Country__c":"xxxxxx","Label__c":"NL","End_user__c":"NL","Vendor__c":"MACYS","Division__c":"FOB","Retailer_Brand__c":"MMG","Royalty_Rate__c":"USA","Market__c":"USA","Remarks__c":"CHINA","LOB__c":"AAF","SO_Number__c":"18001464","Production_Country__c":"CHINA","Local_Currency__c":"HKD","Gross_Sales_USD__c":"10"}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = '2 - Data Validation In Progress';
        value.Record_Type__c = 'Sales';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        value.Success_Notification__c = true;
        value.Reprocessing__c = false;
        insert value;
        
        Sales_Transaction_Stage__c salesTranscation = new Sales_Transaction_Stage__c();
        salesTranscation.Vendor__c= 'JC PENNEY';
        salesTranscation.Model__c = 'CS1Q';
        salesTranscation.Retailer_Check__c = true;
        salesTranscation.Model_Check__c = True;
        salesTranscation.Record_Status__c = '2 - Data Validation Successful';
        salesTranscation.Upload_Batch_No__c = value.Id;
        salesTranscation.Unit_Sold__c = '123';
        salesTranscation.Unit_Price_100_EUR__c = '12';
        salesTranscation.Unit_Price_100_USD__c = '675';
        salesTranscation.Sales_EUR__c = '11';
        salesTranscation.Sales_USD__c = '121';
        salesTranscation.ExRate_to_EUR__c ='321';
        salesTranscation.ExRate_to_USD__c = '521';
        salesTranscation.Local_Net_Unit_Pirce_100__c = '989';
        salesTranscation.Sales_Transaction_Currency__c = '525';
        salesTranscation.Gross_Sales_USD__c = '125';
        salesTranscation.Freight_Charge_USD__c = '323';
      	
         //salesTranscation.Upload_Batch_No__c = 'a1Np000000IxgVIEAZ';
        insert salesTranscation;
        
        ContentVersion invenotryFile = new ContentVersion();
        invenotryFile.ContentLocation = 'S';
        invenotryFile.VersionData = Blob.valueOf(csv);
        invenotryFile.Title = 'Inventory Data File Uplaod';
        invenotryFile.PathOnClient = fileName; 
        //invenotryFile.IsLatest = true;
        insert invenotryFile;   
        
        ContentVersion inventoryVerContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :invenotryFile.Id];            
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=value.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=inventoryVerContent.ContentDocumentId;            
        insert contentlink;       
        
        inventory_azure_storage_details__c customdataInv = new inventory_azure_storage_details__c();
        customdataInv.storageKey__c ='jvgVaNt0NiDwLOuvX9HX5M8hliJF4TI1cQmKcfnALKpTJ6hJ5mtoX0ST2MaKdYEmTbJgCr89keEc8xvQltoF1A==';
        customdataInv.storageName__c = 'mpdm01';
        customdataInv.containerName__c = 'inventory-file';
        insert customdataInv;
        
        

       // Inventory_Transaction_Master__c inventoryTransMast = new Inventory_Transaction_Master__c();
        salesAdminAccessClass.getRetailerData(value.Id);
        salesAdminAccessClass.getModelData(value.Id);
        //salesAdminAccessClass.recStatusUpsertForInventory(salesTranscation.Id);
        salesAdminAccessClass.recStatusUpsertForInventory(value.Id);
        salesAdminAccessClass.recUpdateFOrInvSuccess(value.Id);
        salesAdminAccessClass.recUpdateFOrInvFailure(value.Id);
        string userEmail = UserInfo.getUserEmail();
        string batchId = salesTranscation.Id;
         //string batchId = value.Id;
        
        salesSuccessData obj = new salesSuccessData(value.Id,userEmail);
        Test.setMock(HttpCalloutMock.class, new SalesSuccesDataHttpWebService()); 
        obj.createCSVFileAndUploadToAzure(value.Id);
        getMasterData getMaster = new getMasterData();
        getMaster.getCSVFile(value.id);
       
    }

}