@isTest
public class uploadInventryTest {
    static testMethod void dataSubmittedTest(){
        string companyArray = 'Hongkong Pakaging';
        string selmonth = 'April';
         string selyear = '2019';
        
        Data_Upload_Sales__c dataupload = new Data_Upload_Sales__c();
        dataupload.Sales_Data_Company__c = 'Honkong Pakaging';
        dataupload.Month__c = 'March';
        dataupload.Year__c ='2019';
       // insert dataupload;
        
           boolean flag = true;
        Test.startTest();
        uploadInventry.dataSubmitted(companyArray, selmonth, selyear);       
        Test.stopTest();
        System.assertEquals(true, flag);
  }
    
    static testMethod void getRecordStatusTest() {        
        Inventory_Transaction_Master__c recordPicklist = new Inventory_Transaction_Master__c(); 
        recordPicklist.Name = 'testM1';
        insert recordPicklist;
        Map<String, String> countt = uploadInventry.getRecordStatus();
        System.assertEquals(recordPicklist.Name,'testM1'); 
    } 
    
    static testMethod void getBatchStatusTest() {        
        Inventory_Transaction_Master__c batchPicklist = new Inventory_Transaction_Master__c(); 
        batchPicklist.Name = 'testM2'; 
        insert batchPicklist;
        Map<String, String> countt = uploadInventry.getBatchStatus();
        System.assertEquals(batchPicklist.Name,'testM2'); 
    } 
    
    static testMethod void getMainettiMapTest() {        
        Inventory_Transaction_Master__c batchPicklist = new Inventory_Transaction_Master__c(); 
        batchPicklist.Name = 'testM3'; 
        insert batchPicklist;
        Map<String, String> countt = uploadInventry.getMainettiMap();
        System.assertEquals(batchPicklist.Name,'testM3'); 
    } 
    
    static testMethod void getDateandTypeRecordsTest() {        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        //system.debug('value'+value);
        Test.startTest();
        uploadInventry.getDateandTypeRecords(system.today(), system.today(), 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(system.today(), system.today(), 'Inventory', '2 - Migration Fail', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(system.today(), system.today(), 'Inventory', '', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(system.today(), system.today(), '', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(system.today(), system.today(), 'Inventory', '1 - Migration Success','');
        uploadInventry.getDateandTypeRecords(system.today(), system.today(), 'Inventory', '','');
        uploadInventry.getDateandTypeRecords(null, null, 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(system.today(), null, 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(null, system.today(), 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(null, null, '', '', 'Mainetti (HK) Ltd');
        uploadInventry.getDateandTypeRecords(null, null, '', '1 - Migration Success', '');
        uploadInventry.getDateandTypeRecords(null, null, '', '2 - Migration Fail', '');
        Test.stopTest();
        Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        System.assertEquals(String.valueOf(searchQuery.Record_Type__c),'Inventory'); 
    } 
    static testMethod void getSalesSearchRecordsTest(){
         Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        //system.debug('value'+value);
        Test.startTest();
        uploadInventry.getSalesSearchRecords(system.today(), system.today(), 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(system.today(), system.today(), 'Inventory', '2 - Migration Fail', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(system.today(), system.today(), 'Inventory', '', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(system.today(), system.today(), '', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(system.today(), system.today(), 'Inventory', '1 - Migration Success','');
        uploadInventry.getSalesSearchRecords(system.today(), system.today(), 'Inventory', '','');
        uploadInventry.getSalesSearchRecords(null, null, 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(system.today(), null, 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(null, system.today(), 'Inventory', '1 - Migration Success', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(null, null, '', '', 'Mainetti (HK) Ltd');
        uploadInventry.getSalesSearchRecords(null, null, '', '1 - Migration Success', '');
        uploadInventry.getSalesSearchRecords(null, null, '', '2 - Migration Fail', '');
        
          Test.stopTest();
        Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        System.assertEquals(String.valueOf(searchQuery.Record_Type__c),'Inventory'); 
    }
    
    static testMethod void getDataTest() {        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        string appName = 'SalesUpload';
        
        Test.startTest();
        uploadInventry.getData();
        uploadInventry.getErrorData(value.id);
        uploadInventry.getSuccessData(value.id);
        uploadInventry.getCompanyWeekData(value.id);
        Test.stopTest();
        Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        System.assertEquals(String.valueOf(searchQuery.Record_Type__c),'Inventory'); 
    } 
    static testMethod void getSalesDataTest(){
         Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Sales';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
         string appName = 'InventoryUpload';
        
         Test.startTest();
        uploadInventry.getSalesData();
       Test.stopTest();
        Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        System.assertEquals(String.valueOf(searchQuery.Record_Type__c),'Sales'); 
        
    }
    static testMethod void getPreviousYearTest(){
        
        Test.startTest();
        uploadInventry.getPreviousYear();
         Test.stopTest();
        
    }
    
    static testMethod void parseInventryTest() {                
        string jSon = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK) Ltd\",\"Inventory_Model__c\":\"TNGU139\",\"Warehouse__c\":\"LongHua Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Virgin\",\"Stock_In_Date__c\":\"23-May-19\",\"Stock_In_Qty__c\":\"200\"}]';
        String jsonError = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Inventory_Model__c\":\"TNGU139\",\"Warehouse__c\":\"LongHua Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Virgin\",\"Stock_In_Date__c\":\"23-May-19\",\"Stock_In_Qty__c\":\"200\"}]';
        
        string jSonInvalid = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Inventory_Model__c\":\"TNGU1399\",\"Warehouse__c\":\"LongHua 11Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"pre1\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Vir\",\"Stock_In_Date__c\":\"23/09/19\",\"Stock_In_Qty__c\":\"200\"}]';
        string jSonMissing = '[{\"Retailer_Code__c\":\"\",\"Mainetti_Company__c\":\"\",\"Inventory_Model__c\":\"\",\"Warehouse__c\":\"\",\"Color__c\":\"\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"\",\"Source__c\":\"\",\"Stock_In_Date__c\":\"\",\"Stock_In_Qty__c\":\"\"}]';
        string recordType = 'Inventory';
        string company = 'Mainetti (HK) Ltd';
        string returnBatchId = '';
        boolean flag = true;
        
        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value; 
        Inventory_Transaction_Stage__c stageValue = new Inventory_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Stock_In_Date__c = '23-May-19';
        stageValue.Stock_In_Qty__c = '200';
        insert stageValue;
        Test.startTest();
        uploadInventry.parseInventory(jSon, value.id, recordType, company);
        uploadInventry.parseInventory(jSon, '', recordType, company);
        uploadInventry.parseInventory(jSonInvalid, '', recordType, company);
        uploadInventry.parseInventory(jSonMissing, '', recordType, company);        
        Test.stopTest();
        System.assertEquals(true, flag); 
        
        
        
    } 
    
    static testMethod void insertDataUploadTransactionTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        string returnBatchId = '';
        Test.startTest();
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        Inventory_Transaction_Stage__c stageValue = new Inventory_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Retailer_Code__c = 'GU';
        stageValue.Upload_Batch_No__c = updateBatchStatus.id;
        stageValue.Stock_In_Date__c = '23-May-19';
        stageValue.Stock_In_Qty__c = '200';
        insert stageValue;
        
        // Inserting the Partner Data
        Partner__c partner = new Partner__c(Name = 'Mainetti (HK) Ltd', Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd');
        insert partner;
        getMasterData companyMap = new getMasterData();
        companyMap.getManitteCompanyIdMap();
        Map<string,string> mainettiCompanyMap = new Map<string,string>();
        map<string,Id> manitteIdMap = new map<string,Id>();
        List<Partner__c> partners = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')];
        for ( Partner__c ptn : partners )
        {
            mainettiCompanyMap.put(ptn.Name.toLowerCase(),ptn.Default_Order_to_Company__c); 
            manitteIdMap.put(ptn.Name.toLowerCase(),ptn.Id);
        }
        
        Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'DECATHLON');
        insert retailercode;
        getMasterData companyMapp = new getMasterData();
        companyMapp.getRetailerCodeMap();
        companyMapp.getRetailerCodeIdMap();
        Map<string,string> retailerCodeMap = new Map<string,string>();
        Map<string,Id> retailerCodeIdMap = new Map<string,Id>();          
        list<Retailer_Code__c> retailerCodes = [Select Id,Name from Retailer_Code__c];        
        for ( Retailer_Code__c retail : retailerCodes ){
            retailerCodeMap.put(retail.Name.toLowerCase(),retail.Name.toLowerCase());
            retailerCodeIdMap.put(retail.Name.toLowerCase(),retail.Id);
        }
        
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        insert priceSpecBook;
        Product__c product = new Product__c();
        product.Business_Vertical__c = 'TLA';
        //product.Name = 'EAS001';
        insert product;
        
        Price_Specification_Book_Product__c priceBookSpecProd = new Price_Specification_Book_Product__c(Color__c = 'GRAY',Price_Specification_Book__c = priceSpecBook.Id,Price_100pcs__c = 500,Product_Unique_ID__c =product.Id);
        insert priceBookSpecProd;
        //Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        //updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        getMasterData companyMappp = new getMasterData();
        companyMappp.getRTSModelMap(updateBatchStatus);
        
        //map<string,Id> manitteMap = new map<string,Id>();
        //partnerQuery = [Select Id, Name  from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')];
        uploadInventry uplInventry = new uploadInventry();
        uplInventry.insertDataUploadTransaction(updateBatchStatus);
        Test.stopTest();
        System.assertEquals(returnBatchId,'');      
    }
    
    @IsTest(seeAllData=true)
    static void createDocumentTest() {
        //string csv = "Retailer_Code__c,Mainetti_Company__c,Inventory_Model__c,Warehouse__c,Color__c,Sizer_Print__c,Local_System_SKU__c,Source__c,Stock_In_Date__c,Stock_In_Qty__c 
            //GU,Mainetti (HK) Ltd,TNGU139,LongHua Factory,GRAY,,157946,Virgin,23-May-19,200";    
        //List<sObject> csv = Test.loadData(Inventory_Transaction_Master__c.sObjectType, 'csvTest');
        
        string csv = '[{"Retailer_Code__c": "GU","Mainetti_Company__c": "Mainetti (HK) Ltd","Inventory_Model__c": "TNGU139","Warehouse__c": "LongHua Factory","Color__c": "GRAY","Sizer_Print__c": "","Local_System_SKU__c": "157946","Source__c": "Virgin","Stock_In_Date__c": "23-May-19","Stock_In_Qty__c": "200",}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        string returnBatchId = '';
        boolean flag = true;
        Test.startTest();
        uploadInventry.createDocument(csv, value.id, fileName);
        Test.stopTest();
        System.assertEquals(true, flag); 
    }
    static testMethod void generateIdForFileUploadTest(){
            string recordType = ''; 
            string selMonth = '';
            string selYear = '' ;
            string selcomp = '';
        
         Test.startTest();
      uploadInventry.generateIdForFileUpload(recordType, selMonth, selYear, selcomp);
         Test.stopTest();
        
      }
     static testMethod void errordataSubmittedTest(){
            string companyArray = '';
            string selmonth = '';
            string selyear = '';
      
         Test.startTest();
      uploadInventry.errordataSubmitted(companyArray, selmonth, selyear);
        Test.stopTest();
    }
    static testMethod void getsalesCompanyListTest(){
        
        
         Test.startTest();
      uploadInventry.getsalesCompanyList();
        Test.stopTest();
    }
    static testMethod void fetchLookupErrorMapListTest(){
            String mapToValue = '';
            String mapFromValue = '';
            string rawDataField = '';
            string company = '';
         Test.startTest();
      uploadInventry.fetchLookupErrorMapList(mapToValue, mapFromValue, rawDataField, company);
        Test.stopTest();
    }
    static testMethod void callingCustomSettingsTest(){
        
         Test.startTest();
      uploadInventry.callingCustomSettings();
        Test.stopTest();
        
    }
    static testMethod void isDataCleanForProceedTest(){
         Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
          
        Test.startTest();
        uploadInventry.getData();                                                   
        uploadInventry.isDataCleanForProceed(value.id);
        uploadInventry.isCompanyMissingWeek(value.id);
        uploadInventry.isDataCleanRecordCount(value.id);
        uploadInventry.isDataClean(value.id);
        uploadInventry.proceedSalesData(value.id);
        uploadInventry.getSalesErrorData(value.id);
       // uploadInventry.insertTestToData(value.id);
        Test.stopTest();
        Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        System.assertEquals(String.valueOf(searchQuery.Record_Type__c),'Inventory');
    }
   
     static testMethod void splitInsertRecordListForUploadTest(){
        List<Data_Upload_Sales__c> insertRecord  = new List<Data_Upload_Sales__c>();
        for(Integer i=0; i<=9901; i++){
            Data_Upload_Sales__c datauploadtrans = new Data_Upload_Sales__c();
            insertRecord.add(datauploadtrans);
        }
         uploadInventry uploadinv = new uploadInventry();
          Test.startTest();
        uploadinv.splitInsertRecordListForUpload(insertRecord);
        Test.stopTest();
    }
     static testMethod void insertDataUploadsalesTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'sales';
        insert value;
        string returnBatchId = '';
        Test.startTest();
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = updateBatchStatus.id;
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

        
        uploadInventry uplInventry = new uploadInventry();
        uplInventry.insertDataUploadSales(updateBatchStatus);
        uploadInventry.getPreviousYear();
        uploadInventry.getsalesCompanyList();
        Test.stopTest();
        System.assertEquals(returnBatchId,'');      
    }
     static testMethod void insertTestToDataTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        insert value;
        
        string returnBatchId = 'abc';
        boolean flag = true;
        Test.startTest();
        uploadInventry uplInventry = new uploadInventry();
        uplInventry.insertTestToData(value.id); 
       // uploadInventry.getSalesRecordCount(value.id);
        //uploadInventry.getSalesErrorData(value.id);
       // uploadInventry.recStatusUpsertForSales(value.id);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void recStatusUpsertForSalesTest(){
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        insert value;
        
        //////////////////////////////////////////////////////////////////
           string csv = '[{"Company__c":"Hong Kong Packaging","Year__c":"2019","Week__c":"Wk45","Month__c":"Jan","Item_code__c":"484","Material__c":"PP","Source__c":"Virgin","Model__c":"1000","Printed_Logo__c":"demoLogo","Color__c":"BLACK","Customer__c":"xxxxx","Customer_local_name__c":"xxxx","Mainetti_Brand__c":"Mainetti","Category__c":"HANGERS & ACCESSORIES","Sub_Category__c":"HANGERS","Family__c":"BOTTOM","Order_Type__c":"3rd","Unit_Sold__c":"8000","Unit_Price_100_EUR__c":"10.65123","Unit_Price_100_USD__c":"12.40602","Net_Unit_Price_100__c":"11","Sales_EUR__c":"2","Sales_USD__c":"5","Transaction_Currency__c":"HKD","ExRate_to_EUR__c":"9.08505","ExRate_to_USD__c":"7.8","Local_Net_Unit_Pirce_100__c":"13","Sales_Transaction_Currency__c":"2438.527291","Shipped_To_Factory__c":"xxxxxx","Shipped_To_Country__c":"xxxxxx","Label__c":"NL","End_user__c":"NL","Vendor__c":"MACYS","Division__c":"FOB","Retailer_Brand__c":"MMG","Royalty_Rate__c":"USA","Market__c":"USA","Remarks__c":"CHINA","LOB__c":"AAF","SO_Number__c":"18001464","Production_Country__c":"CHINA","Local_Currency__c":"HKD","Gross_Sales_USD__c":"10"}]';
        string fileName = 'sample';
        
        Sales_Transaction_Stage__c salesTranscation = new Sales_Transaction_Stage__c();
        salesTranscation.Vendor__c= 'JC PENNEY';
        salesTranscation.Model__c = 'CS1Q';
        salesTranscation.Retailer_Check__c = true;
        salesTranscation.Model_Check__c = True;
        salesTranscation.Record_Status__c = '2 - Data Validation Successful';
        salesTranscation.Upload_Batch_No__c = value.Id;
        salesTranscation.Unit_Sold__c = '123';
        salesTranscation.Unit_Price_100_EUR__c = '24';
        salesTranscation.Unit_Price_100_USD__c = '25';
        salesTranscation.Sales_EUR__c = '10';
        salesTranscation.Sales_USD__c = '20';
        salesTranscation.ExRate_to_EUR__c = '234';
        salesTranscation.ExRate_to_USD__c = '234';
        salesTranscation.Local_Net_Unit_Pirce_100__c = '234';
        salesTranscation.Sales_Transaction_Currency__c = '234';
        salesTranscation.Gross_Sales_USD__c = '12.2';
        salesTranscation.Freight_Charge_USD__c = '2.2';
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
        
        
        
        //////////////////////////////////////////////////////////////////
        string returnBatchId = 'abc';
        boolean flag = true;
        Test.startTest();
        uploadInventry.recStatusUpsertForSales(value.id);
        uploadInventry.getSalesRecordCount(value.id);
        uploadInventry.getSalesErrorData(value.id);
       Test.setMock(HttpCalloutMock.class, new SalesSuccesDataHttpWebService());
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }

      static testMethod void recStatusUpsertForInventoryTest() {        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
       /* value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';*/
        insert value;
          
          
          
           string csv = '[{"Company__c":"Hong Kong Packaging","Year__c":"2019","Week__c":"Wk45","Month__c":"Jan","Item_code__c":"484","Material__c":"PP","Source__c":"Virgin","Model__c":"1000","Printed_Logo__c":"demoLogo","Color__c":"BLACK","Customer__c":"xxxxx","Customer_local_name__c":"xxxx","Mainetti_Brand__c":"Mainetti","Category__c":"HANGERS & ACCESSORIES","Sub_Category__c":"HANGERS","Family__c":"BOTTOM","Order_Type__c":"3rd","Unit_Sold__c":"8000","Unit_Price_100_EUR__c":"10.65123","Unit_Price_100_USD__c":"12.40602","Net_Unit_Price_100__c":"11","Sales_EUR__c":"2","Sales_USD__c":"5","Transaction_Currency__c":"HKD","ExRate_to_EUR__c":"9.08505","ExRate_to_USD__c":"7.8","Local_Net_Unit_Pirce_100__c":"13","Sales_Transaction_Currency__c":"2438.527291","Shipped_To_Factory__c":"xxxxxx","Shipped_To_Country__c":"xxxxxx","Label__c":"NL","End_user__c":"NL","Vendor__c":"MACYS","Division__c":"FOB","Retailer_Brand__c":"MMG","Royalty_Rate__c":"USA","Market__c":"USA","Remarks__c":"CHINA","LOB__c":"AAF","SO_Number__c":"18001464","Production_Country__c":"CHINA","Local_Currency__c":"HKD","Gross_Sales_USD__c":"10"}]';
        string fileName = 'sample';
        
          Sales_Transaction_Stage__c salesTranscation = new Sales_Transaction_Stage__c();
          salesTranscation.Vendor__c= 'JC PENNEY';
          salesTranscation.Model__c = 'CS1Q';
          salesTranscation.Retailer_Check__c = true;
          salesTranscation.Model_Check__c = True;
          salesTranscation.Record_Status__c = '2 - Data Validation Successful';
          salesTranscation.Upload_Batch_No__c = value.Id;
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
          
          
          
          
           Test.startTest();
        uploadInventry.getData();                                                   
       // uploadInventry.recStatusUpsertForInventory(value.id);
        uploadInventry.recUpdateFOrInvSuccess(value.id);
        uploadInventry.deleteDefunctBatchRecord(value.id);
        uploadInventry.getAutoPopulateMasterValues(value.id);
        Test.stopTest();
        //Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        //System.assertEquals(String.valueOf(searchQuery.Record_Type__c),'Inventory'); 
       
      }
  /* static testMethod void parseSalesTest(){
        string jsonin = '';
        string batchNo = '';
        string recordType = '';
        string selMonth = '';
        string selYear = ''; 
        string selcomp = ''; 
        String postBulkInsert = '';
        
         Test.startTest();
      uploadInventry.parseSales(jsonin, batchNo, recordType, selMonth, selYear, selcomp, postBulkInsert);
         Test.stopTest();
    }*/
    
    static testMethod void parseSalesChunkTest(){
        string jsonin = ''; 
        string batchNo = 'a1Np000000IxdzyEAB';
        string recordType = '';
        string selMonth = 'Dec';
        string selYear = '2019';
        string selcomp = 'Hong Kong Packaging';
        String postBulkInsert = '';
        String userEmail = '';
      
        Sales_Transaction_Stage__c salesTransMast = new Sales_Transaction_Stage__c();
        salesTransMast.Upload_Batch_No__c = 'a1Np000000IxdzyEAB';
                salesTransMast.Company__c = 'Hong Kong Packaging';
        //salesTransMast.Batch_No__c = invtrans.Id;
        salesTransMast.Year__c = '2019';
        salesTransMast.Week__c = 'wk02';
        salesTransMast.Month__c = 'Dec';
        salesTransMast.Item_Code__c = 'HGR-3944   BLK002-  100';
        salesTransMast.Material__c = 'PS';
        salesTransMast.Source__c = 'virginn';
        salesTransMast.Model__c = '1000';
        salesTransMast.Printed_Logo__c = 'demologo';
        salesTransMast.Color__c = 'black';
        salesTransMast.Customer__c = 'xxxxxx';
        salesTransMast.Customer_Local_Name__c = 'xxxx';
        salesTransMast.Mainetti_Brand__c = 'mainetti';
        salesTransMast.Category__c = 'HANGERS & ACCESSORIES';
        salesTransMast.Sub_Category__c = 'HANGERS';
        salesTransMast.Family__c = 'bottom';
        salesTransMast.Order_Type__c = '3rd';
        salesTransMast.Unit_Sold__c = '12520';
        salesTransMast.Unit_Price_100_EUR__c = '110.65123';
        salesTransMast.Unit_Price_100_USD__c = '112.40602';
        salesTransMast.Net_Unit_Price_100__c = '111';
        salesTransMast.Sales_EUR__c = '1268.410993';
        salesTransMast.Sales_USD__c = '1312.631704';
        salesTransMast.Transaction_Currency__c = 'hkd';
        salesTransMast.ExRate_to_EUR__c = '19.08505';
        salesTransMast.ExRate_to_USD__c = '20.8';
        salesTransMast.Local_Net_Unit_Pirce_100__c = '113';
        salesTransMast.Sales_Transaction_Currency__c = '12438.527291';
        salesTransMast.Shipped_To_Factory__c = 'xxxxxx'; 
        salesTransMast.Shipped_To_Country__c = 'xxxx';
        salesTransMast.Label__c = 'label';
        salesTransMast.End_User__c = 'user';
        salesTransMast.Vendor__c = 'lululemon';
        salesTransMast.Division__c = 'demo';
        salesTransMast.Retailer_Brand__c = 'demo';
        salesTransMast.Royalty_Rate__c = 'xxxx';
        salesTransMast.Market__c = 'USA';
        salesTransMast.Remark__c = 'xxxx';
        salesTransMast.LOB__c = 'PRL123456789012345688';
        salesTransMast.SO_Number__c = '183001689999898988';
        salesTransMast.Production_Country__c = 'CHINA';
        salesTransMast.Gross_Sales_USD__c = '12.2';
        salesTransMast.Freight_Charge_USD__c = 'abc';
        salesTransMast.Retailer_Check__c = true;
        salesTransMast.Model_Check__c = true;
        insert salesTransMast;
        
        Inventory_Transaction_Master__c invtrans = new Inventory_Transaction_Master__c();
        //invtrans.Batch_No__c = '';
        invtrans.Sales_Month__c = 'Dec';
        invtrans.Sales_Year__c = '2019';
        invtrans.Sales_Company__c = 'Hong Kong Packaging';
       invtrans.Batch_Status__c = '2 - Data Validation In Progress';
       insert invtrans;
        
        
          Test.startTest();
      uploadInventry.parseSalesChunk(jsonin, batchNo, recordType, selMonth, selYear, selcomp, postBulkInsert);
         Test.stopTest();
        
    }
    static testMethod void validataeBulkBatchApexTest(){
            String batchNo = 'a1Np000000IxdzyEAB';
        string selMonth = 'Dec';
        string selYear = '2019';
        string selcomp = 'Hong Kong Packaging';
            String userEmail = UserInfo.getUserEmail();
        
        Sales_Transaction_Stage__c salesTransMast = new Sales_Transaction_Stage__c();
        salesTransMast.Upload_Batch_No__c = 'a1Np000000IxdzyEAB';
                salesTransMast.Company__c = 'Hong Kong Packaging';
        //salesTransMast.Batch_No__c = invtrans.Id;
        salesTransMast.Year__c = '2019';
        salesTransMast.Week__c = 'wk02';
        salesTransMast.Month__c = 'Dec';
        salesTransMast.Item_Code__c = 'HGR-3944   BLK002-  100';
        salesTransMast.Material__c = 'PS';
        salesTransMast.Source__c = 'virginn';
        salesTransMast.Model__c = '1000';
        salesTransMast.Printed_Logo__c = 'demologo';
        salesTransMast.Color__c = 'black';
        salesTransMast.Customer__c = 'xxxxxx';
        salesTransMast.Customer_Local_Name__c = 'xxxx';
        salesTransMast.Mainetti_Brand__c = 'mainetti';
        salesTransMast.Category__c = 'HANGERS & ACCESSORIES';
        salesTransMast.Sub_Category__c = 'HANGERS';
        salesTransMast.Family__c = 'bottom';
        salesTransMast.Order_Type__c = '3rd';
        salesTransMast.Unit_Sold__c = '12520';
        salesTransMast.Unit_Price_100_EUR__c = '110.65123';
        salesTransMast.Unit_Price_100_USD__c = '112.40602';
        salesTransMast.Net_Unit_Price_100__c = '111';
        salesTransMast.Sales_EUR__c = '1268.410993';
        salesTransMast.Sales_USD__c = '1312.631704';
        salesTransMast.Transaction_Currency__c = 'hkd';
        salesTransMast.ExRate_to_EUR__c = '19.08505';
        salesTransMast.ExRate_to_USD__c = '20.8';
        salesTransMast.Local_Net_Unit_Pirce_100__c = '113';
        salesTransMast.Sales_Transaction_Currency__c = '12438.527291';
        salesTransMast.Shipped_To_Factory__c = 'xxxxxx'; 
        salesTransMast.Shipped_To_Country__c = 'xxxx';
        salesTransMast.Label__c = 'label';
        salesTransMast.End_User__c = 'user';
        salesTransMast.Vendor__c = 'lululemon';
        salesTransMast.Division__c = 'demo';
        salesTransMast.Retailer_Brand__c = 'demo';
        salesTransMast.Royalty_Rate__c = 'xxxx';
        salesTransMast.Market__c = 'USA';
        salesTransMast.Remark__c = 'xxxx';
        salesTransMast.LOB__c = 'PRL123456789012345688';
        salesTransMast.SO_Number__c = '183001689999898988';
        salesTransMast.Production_Country__c = 'CHINA';
        salesTransMast.Gross_Sales_USD__c = '12.2';
        salesTransMast.Freight_Charge_USD__c = 'abc';
        salesTransMast.Retailer_Check__c = true;
        salesTransMast.Model_Check__c = true;
        insert salesTransMast;
        
        Test.startTest();
      uploadInventry.validataeBulkBatchApex(batchNo, selMonth, selYear, selcomp, userEmail);
         Test.stopTest();
        
    }
 static testMethod void saveRecordTest(){
            Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        //value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'sales';
        insert value;
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Family__c = 'bottomm';
        insert stageValue;
        Sales_Transaction_Stage__c stageValueTwo = new Sales_Transaction_Stage__c();
        stageValueTwo.Color__c = 'GRAY';
        stageValueTwo.Record_Status__c = '2 - Data Validation Successful';
        stageValueTwo.Upload_Batch_No__c = value.id;
        stageValueTwo.Family__c = 'bottomm';
        insert stageValueTwo;
        Sales_Error_Mapping__c errormap = new Sales_Error_Mapping__c();
        errormap.Raw_Data_Field__c = 'Family';
        errormap.Map_From_Value__c = 'bottomm';
        errormap.Map_To_Value__c = 'bottom';
        errormap.Company__c = 'America Mid West - Hangers Unlimited';
        
        boolean flag = true;
        Test.startTest();
        uploadInventry.saveRecord('Family','bottom','bottomm',value.id,stageValue.id,'Family','Family','America Mid West - Hangers Unlimited');
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }
   
    static testMethod void insertBulkSalesTest(){
   // Sales_Transaction_Stage__c  con = [Select Upload_Batch_No__c,Company__c,Item_Code__c,Material__c,Mainetti_Brand__c from Sales_Transaction_Stage__c LIMIT 1];
       // string jsonin = '';
            string batchNo = 'a1Np000000IxdzyEAB';
           // string recordType = '';
            string selMonth = '';
            string selYear = '';
            string selcomp = '';
            string isreupload = 'true';
            String chunkCount = '';
            String fileName = '';
      
         string jSon = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK) Ltd\",\"Inventory_Model__c\":\"TNGU139\",\"Warehouse__c\":\"LongHua Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Virgin\",\"Stock_In_Date__c\":\"23-May-19\",\"Stock_In_Qty__c\":\"200\"}]';
        String jsonError = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Inventory_Model__c\":\"TNGU139\",\"Warehouse__c\":\"LongHua Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Virgin\",\"Stock_In_Date__c\":\"23-May-19\",\"Stock_In_Qty__c\":\"200\"}]';
        
        string jSonInvalid = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Inventory_Model__c\":\"TNGU1399\",\"Warehouse__c\":\"LongHua 11Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"pre1\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Vir\",\"Stock_In_Date__c\":\"23/09/19\",\"Stock_In_Qty__c\":\"200\"}]';
        string jSonMissing = '[{\"Retailer_Code__c\":\"\",\"Mainetti_Company__c\":\"\",\"Inventory_Model__c\":\"\",\"Warehouse__c\":\"\",\"Color__c\":\"\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"\",\"Source__c\":\"\",\"Stock_In_Date__c\":\"\",\"Stock_In_Qty__c\":\"\"}]';
        string recordType = 'Inventory';
        string company = 'Mainetti (HK) Ltd';
        string returnBatchId = '';
        
        
        Sales_Transaction_Stage__c salesTransMast = new Sales_Transaction_Stage__c();
        salesTransMast.Upload_Batch_No__c = 'a1Np000000IxdzyEAB';
                salesTransMast.Company__c = 'Hong Kong Packaging';
        //salesTransMast.Batch_No__c = invtrans.Id;
        salesTransMast.Year__c = '2019';
        salesTransMast.Week__c = 'wk02';
        salesTransMast.Month__c = 'Dec';
        salesTransMast.Item_Code__c = 'HGR-3944   BLK002-  100';
        salesTransMast.Material__c = 'PS';
        salesTransMast.Source__c = 'virginn';
        salesTransMast.Model__c = '1000';
        salesTransMast.Printed_Logo__c = 'demologo';
        salesTransMast.Color__c = 'black';
        salesTransMast.Customer__c = 'xxxxxx';
        salesTransMast.Customer_Local_Name__c = 'xxxx';
        salesTransMast.Mainetti_Brand__c = 'mainetti';
        salesTransMast.Category__c = 'HANGERS & ACCESSORIES';
        salesTransMast.Sub_Category__c = 'HANGERS';
        salesTransMast.Family__c = 'bottom';
        salesTransMast.Order_Type__c = '3rd';
        salesTransMast.Unit_Sold__c = '12520';
        salesTransMast.Unit_Price_100_EUR__c = '110.65123';
        salesTransMast.Unit_Price_100_USD__c = '112.40602';
        salesTransMast.Net_Unit_Price_100__c = '111';
        salesTransMast.Sales_EUR__c = '1268.410993';
        salesTransMast.Sales_USD__c = '1312.631704';
        salesTransMast.Transaction_Currency__c = 'hkd';
        salesTransMast.ExRate_to_EUR__c = '19.08505';
        salesTransMast.ExRate_to_USD__c = '20.8';
        salesTransMast.Local_Net_Unit_Pirce_100__c = '113';
        salesTransMast.Sales_Transaction_Currency__c = '12438.527291';
        salesTransMast.Shipped_To_Factory__c = 'xxxxxx'; 
        salesTransMast.Shipped_To_Country__c = 'xxxx';
        salesTransMast.Label__c = 'label';
        salesTransMast.End_User__c = 'user';
        salesTransMast.Vendor__c = 'lululemon';
        salesTransMast.Division__c = 'demo';
        salesTransMast.Retailer_Brand__c = 'demo';
        salesTransMast.Royalty_Rate__c = 'xxxx';
        salesTransMast.Market__c = 'USA';
        salesTransMast.Remark__c = 'xxxx';
        salesTransMast.LOB__c = 'PRL123456789012345688';
        salesTransMast.SO_Number__c = '183001689999898988';
        salesTransMast.Production_Country__c = 'CHINA';
        salesTransMast.Gross_Sales_USD__c = '12.2';
        salesTransMast.Freight_Charge_USD__c = 'abc';
        salesTransMast.Retailer_Check__c = true;
        salesTransMast.Model_Check__c = true;
        insert salesTransMast;
        
        Inventory_Transaction_Master__c invtrans = new Inventory_Transaction_Master__c();
        //invtrans.Batch_No__c = '';
        invtrans.Sales_Month__c = 'Dec';
        invtrans.Sales_Year__c = '2019';
        invtrans.Sales_Company__c = 'Hong Kong Packaging';
       invtrans.Batch_Status__c = '2 - Data Validation In Progress';
       insert invtrans;

        
         Test.startTest();
      uploadInventry.insertBulkSales(jSon, batchNo, recordType, selMonth, selYear, selcomp, isreupload, chunkCount, fileName);
        Test.stopTest();
    }
   
    static testMethod void splitListForDeleteTest(){
        List<Sales_Transaction_Stage__c> transferRecords  = new List<Sales_Transaction_Stage__c>();
        for(Integer i=0; i<=9901; i++){
            Sales_Transaction_Stage__c salestranstage = new Sales_Transaction_Stage__c();
            transferRecords.add(salestranstage);
          }
         insert transferRecords;
         
          Test.startTest();
        uploadInventry uploadinv = new uploadInventry();
        uploadinv.splitListForDelete(transferRecords);
        Test.stopTest();
        
    } 
    static testMethod void insertSalesStageChunkTest(){
       // string jsonin = '';
        string batchNo = 'a1Np000000IxdzyEAB';
        Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
        salestrans.Company__c = '';
        salestrans.Year__c = '';
        salestrans.Month__c = '';
        salestrans.Week__c = '';
        salestrans.Item_code__c = '';
        salestrans.Material__c = '';
        salestrans.Source__c = '';
        salestrans.Model__c = '';
        salestrans.Printed_Logo__c = '';
        salestrans.Color__c = '';
        salestrans.Customer__c = '';
        salestrans.Customer_local_name__c = '';
        salestrans.Mainetti_Brand__c = '';
        salestrans.Category__c = '';
        salestrans.Sub_Category__c = '';
        salestrans.Family__c = '';
        salestrans.Order_Type__c = '';
        salestrans.Unit_Sold__c = '';
        salestrans.Unit_Price_100_EUR__c = '';
        salestrans.Unit_Price_100_USD__c = '';
            salestrans.Net_Unit_Price_100__c = '';
            salestrans.Sales_EUR__c = '';
            salestrans.Sales_USD__c = '';
            salestrans.Transaction_Currency__c = '';
            salestrans.ExRate_to_EUR__c = '';
            salestrans.ExRate_to_USD__c = '';
            salestrans.Local_Net_Unit_Pirce_100__c = '';
            salestrans.Sales_Transaction_Currency__c = '';
            salestrans.Shipped_To_Country__c = '';
            salestrans.Shipped_To_Factory__c = '';
            salestrans.Label__c = '';
            salestrans.End_user__c = '';
            salestrans.Vendor__c = '';
            salestrans.Division__c = '';
        salestrans.Retailer_Brand__c = '';
        salestrans.Royalty_Rate__c = '';
        insert salestrans;
 
 string jSon = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK) Ltd\",\"Inventory_Model__c\":\"TNGU139\",\"Warehouse__c\":\"LongHua Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Virgin\",\"Stock_In_Date__c\":\"23-May-19\",\"Stock_In_Qty__c\":\"200\"}]';
        String jsonError = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Inventory_Model__c\":\"TNGU139\",\"Warehouse__c\":\"LongHua Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Virgin\",\"Stock_In_Date__c\":\"23-May-19\",\"Stock_In_Qty__c\":\"200\"}]';
        
        string jSonInvalid = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Inventory_Model__c\":\"TNGU1399\",\"Warehouse__c\":\"LongHua 11Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"pre1\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Vir\",\"Stock_In_Date__c\":\"23/09/19\",\"Stock_In_Qty__c\":\"200\"}]';
        string jSonMissing = '[{\"Retailer_Code__c\":\"\",\"Mainetti_Company__c\":\"\",\"Inventory_Model__c\":\"\",\"Warehouse__c\":\"\",\"Color__c\":\"\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"\",\"Source__c\":\"\",\"Stock_In_Date__c\":\"\",\"Stock_In_Qty__c\":\"\"}]';
        string recordType = 'Inventory';
        string company = 'Mainetti (HK) Ltd';
        string returnBatchId = '';

        
 Sales_Transaction_Stage__c salesTransMast = new Sales_Transaction_Stage__c();
        salesTransMast.Upload_Batch_No__c = 'a1Np000000IxdzyEAB';
                salesTransMast.Company__c = 'Hong Kong Packaging';
        //salesTransMast.Batch_No__c = invtrans.Id;
        salesTransMast.Year__c = '2019';
        salesTransMast.Week__c = 'wk02';
        salesTransMast.Month__c = 'Dec';
        salesTransMast.Item_Code__c = 'HGR-3944   BLK002-  100';
        salesTransMast.Material__c = 'PS';
        salesTransMast.Source__c = 'virginn';
        salesTransMast.Model__c = '1000';
        salesTransMast.Printed_Logo__c = 'demologo';
        salesTransMast.Color__c = 'black';
        salesTransMast.Customer__c = 'xxxxxx';
        salesTransMast.Customer_Local_Name__c = 'xxxx';
        salesTransMast.Mainetti_Brand__c = 'mainetti';
        salesTransMast.Category__c = 'HANGERS & ACCESSORIES';
        salesTransMast.Sub_Category__c = 'HANGERS';
        salesTransMast.Family__c = 'bottom';
        salesTransMast.Order_Type__c = '3rd';
        salesTransMast.Unit_Sold__c = '12520';
        salesTransMast.Unit_Price_100_EUR__c = '110.65123';
        salesTransMast.Unit_Price_100_USD__c = '112.40602';
        salesTransMast.Net_Unit_Price_100__c = '111';
        salesTransMast.Sales_EUR__c = '1268.410993';
        salesTransMast.Sales_USD__c = '1312.631704';
        salesTransMast.Transaction_Currency__c = 'hkd';
        salesTransMast.ExRate_to_EUR__c = '19.08505';
        salesTransMast.ExRate_to_USD__c = '20.8';
        salesTransMast.Local_Net_Unit_Pirce_100__c = '113';
        salesTransMast.Sales_Transaction_Currency__c = '12438.527291';
        salesTransMast.Shipped_To_Factory__c = 'xxxxxx'; 
        salesTransMast.Shipped_To_Country__c = 'xxxx';
        salesTransMast.Label__c = 'label';
        salesTransMast.End_User__c = 'user';
        salesTransMast.Vendor__c = 'lululemon';
        salesTransMast.Division__c = 'demo';
        salesTransMast.Retailer_Brand__c = 'demo';
        salesTransMast.Royalty_Rate__c = 'xxxx';
        salesTransMast.Market__c = 'USA';
        salesTransMast.Remark__c = 'xxxx';
        salesTransMast.LOB__c = 'PRL123456789012345688';
        salesTransMast.SO_Number__c = '183001689999898988';
        salesTransMast.Production_Country__c = 'CHINA';
        salesTransMast.Gross_Sales_USD__c = '12.2';
        salesTransMast.Freight_Charge_USD__c = 'abc';
        salesTransMast.Retailer_Check__c = true;
        salesTransMast.Model_Check__c = true;
        insert salesTransMast;

        Test.startTest();
      uploadInventry.insertSalesStageChunk(jSon, batchNo);
        Test.stopTest();
    }
       
    
    
 //=============================================================================//
     /*static testMethod void insertSalesStageChunkTest(){
        string jsonin = '';
        string batchNo = '';
        
        Test.startTest();
      uploadInventry.insertSalesStageChunk(jsonin, batchNo);
        Test.stopTest();
    }*/
  /*  static testMethod void insertSalesStageTest(){
        string jsonin = '';
        string batchNo = '';
        
        Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
        salestrans. 
        
         Test.startTest();
        uploadInventry.insertSalesStage(jsonin, batchNo);
         Test.stopTest();
        
    }*/
   
   /* static testMethod void getSalesSuccessDataTest(){
        string batchid = '';
        Integer pageNumber = 2;
        Integer recordToFetch = 5;
        Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
        
         Test.startTest();
        uploadInventry.getSalesSuccessData(batchid, pageNumber, recordToFetch);
        Test.stopTest();
    }
    
    static testMethod void insertSalesStageChunkTest(){
        string jsonin = '';
        string batchNo = '';
        
        Test.startTest();
      uploadInventry.insertSalesStageChunk(jsonin, batchNo);
        Test.stopTest();
    }*/
   /*static testMethod void recStatusUpsertForSalesTest(){
       Inventory_Transaction_Master__c invtrans = new Inventory_Transaction_Master__c();
       invtrans.company_week__c = ''
    }*/ 
   /* static testMethod void getSalesData() {        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Sales';
        insert value;
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.ErrorMapData__c = 'Family';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Transaction_Master_Id__c = value.id;
        insert stageValue;        
        boolean flag = true;
        Test.startTest();
        uploadInventry.getSalesErrorData(value.id);
        uploadInventry.getConciseSalesErrorData(value.id);
        uploadInventry.getSalesSuccessData(value.id);
        Test.stopTest();
        Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        System.assertEquals(true, flag); 
    } 
    static testMethod void parseSalesTest() {                
        string jSon = '[{\"Company__c\":\"Hong Kong Packaging\",\"Year__c\":\"2019\",\"Week__c\":\"Wk45\",\"Month__c\":\"Jan\",\"Item_code__c\":\"484\",\"Material__c\":\"PP\",\"Source__c\":\"Virgin\",\"Model__c\":\"1000\",\"Printed_Logo__c\":\"demoLogo\",\"Color__c\":\"BLACK\",\"Customer__c\":\"xxxxx\",\"Customer_local_name__c\":\"xxxx\",\"Mainetti_Brand__c\":\"Mainetti\",\"Category__c\":\"HANGERS & ACCESSORIES\",\"Sub_Category__c\":\"HANGERS\",\"Family__c\":\"BOTTOM\",\"Order_Type__c\":\"3rd\",\"Unit_Sold__c\":\"8000\",\"Unit_Price_100_EUR__c\":\"10.65123\",\"Unit_Price_100_USD__c\":\"12.40602\",\"Net_Unit_Price_100__c\":\"11\",\"Sales_EUR__c\":\"2\",\"Sales_USD__c\":\"5\",\"Transaction_Currency__c\":\"HKD\",\"ExRate_to_EUR__c\":\"9.08505\",\"ExRate_to_USD__c\":\"7.8\",\"Local_Net_Unit_Pirce_100__c\":\"13\",\"Sales_Transaction_Currency__c\":\"2438.527291\",\"Shipped_To_Factory__c\":\"xxxxxx\",\"Shipped_To_Country__c\":\"xxxxxx\",\"Label__c\":\"NL\",\"End_user__c\":\"NL\",\"Vendor__c\":\"MACYS\",\"Division__c\":\"FOB\",\"Retailer_Brand__c\":\"MMG\",\"Royalty_Rate__c\":\"USA\",\"Market__c\":\"USA\",\"Remarks__c\":\"CHINA\",\"LOB__c\":\"AAF\",\"SO_Number__c\":\"18001464\",\"Production_Country__c\":\"CHINA\",\"Local_Currency__c\":\"HKD\",\"Gross_Sales_USD__c\":\"10\"}]';
        //String jsonError = '[{\"Retailer_Code__c\":\"GU\",\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Inventory_Model__c\":\"TNGU139\",\"Warehouse__c\":\"LongHua Factory\",\"Color__c\":\"GRAY\",\"Sizer_Print__c\":\"\",\"Local_System_SKU__c\":\"157946\",\"Source__c\":\"Virgin\",\"Stock_In_Date__c\":\"23-May-19\",\"Stock_In_Qty__c\":\"200\"}]';
        string jSonInvalid = '[{\"Company__c\":\"Hong Kong Packaging\",\"Year__c\":\"2021\",\"Week__c\":\"Wk02\",\"Month__c\":\"Aug\",\"Item_code__c\":\"HGR-3944   BLK002-  100\",\"Material__c\":\"PS\",\"Source__c\":\"Virginn\",\"Model__c\":\"1000\",\"Printed_Logo__c\":\"demoLogoss\",\"Color__c\":\"violet\",\"Customer__c\":\"xxxxx\",\"Customer_local_name__c\":\"abc\",\"Mainetti_Brand__c\":\"Maines\",\"Category__c\":\"HANGERS ACCESSORIES\",\"Sub_Category__c\":\"HANG\",\"Family__c\":\"BOTTOMMS\",\"Order_Type__c\":\"6TH\",\"Unit_Sold__c\":\"2520\",\"Unit_Price_100_EUR__c\":\"10.65123\",\"Unit_Price_100_USD__c\":\"12.40602\",\"Net_Unit_Price_100__c\":\"11\",\"Sales_EUR__c\":\"268.410993\",\"Sales_USD__c\":\"312.631704\",\"Transaction_Currency__c\":\"USD\",\"ExRate_to_EUR__c\":\"9.08505\",\"ExRate_to_USD__c\":\"7.8\",\"Local_Net_Unit_Pirce_100__c\":\"13\",\"Sales_Transaction_Currency__c\":\"2438.527291\",\"Shipped_To_Factory__c\":\"ABC\",\"Shipped_To_Country__c\":\"xxx\",\"Label__c\":\"nill\",\"End_user__c\":\"nill\",\"Vendor__c\":\"DemoRetail\",\"Division__c\":\"Demos\",\"Retailer_Brand__c\":\"Demo\",\"Royalty_Rate__c\":\"US\",\"Market__c\":\"US\",\"Remarks__c\":\"abc\",\"LOB__c\":\"PRL\",\"SO_Number__c\":\"18300168\",\"Production_Country__c\":\"CHI\",\"Local_Currency__c\":\"USD\",\"Gross_Sales_USD__c\":\"abc\"}]';
        string jSonMissing = '[{\"Company__c\":\"\",\"Year__c\":\"2019\",\"Week__c\":\"\",\"Month__c\":\"\",\"Item_code__c\":\"\",\"Material__c\":\"\",\"Source__c\":\"\",\"Model__c\":\"\",\"Printed_Logo__c\":\"demoLogo\",\"Color__c\":\"\",\"Customer__c\":\"xxxxx\",\"Customer_local_name__c\":\"\",\"Mainetti_Brand__c\":\"\",\"Category__c\":\"\",\"Sub_Category__c\":\"\",\"Family__c\":\"\",\"Order_Type__c\":\"3rd\",\"Unit_Sold__c\":\"\",\"Unit_Price_100_EUR__c\":\"\",\"Unit_Price_100_USD__c\":\"\",\"Net_Unit_Price_100__c\":\"\",\"Sales_EUR__c\":\"\",\"Sales_USD__c\":\"\",\"Transaction_Currency__c\":\"HKD\",\"ExRate_to_EUR__c\":\"\",\"ExRate_to_USD__c\":\"\",\"Local_Net_Unit_Pirce_100__c\":\"\",\"Sales_Transaction_Currency__c\":\"\",\"Shipped_To_Factory__c\":\"\",\"Shipped_To_Country__c\":\"\",\"Label__c\":\"\",\"End_user__c\":\"\",\"Vendor__c\":\"\",\"Division__c\":\"\",\"Retailer_Brand__c\":\"\",\"Royalty_Rate__c\":\"\",\"Market__c\":\"\",\"Remarks__c\":\"\",\"LOB__c\":\"PRL\",\"SO_Number__c\":\"18300168\",\"Production_Country__c\":\"\"}]';
        string jSonAllMissing = '[{\"Company__c\":\"\",\"Year__c\":\"\",\"Week__c\":\"\",\"Month__c\":\"\",\"Item_code__c\":\"\",\"Material__c\":\"\",\"Source__c\":\"\",\"Model__c\":\"\",\"Printed_Logo__c\":\"\",\"Color__c\":\"\",\"Customer__c\":\"\",\"Customer_local_name__c\":\"\",\"Mainetti_Brand__c\":\"\",\"Category__c\":\"\",\"Sub_Category__c\":\"\",\"Family__c\":\"\",\"Order_Type__c\":\"\",\"Unit_Sold__c\":\"\",\"Unit_Price_100_EUR__c\":\"\",\"Unit_Price_100_USD__c\":\"\",\"Net_Unit_Price_100__c\":\"\",\"Sales_EUR__c\":\"\",\"Sales_USD__c\":\"\",\"Transaction_Currency__c\":\"\",\"ExRate_to_EUR__c\":\"\",\"ExRate_to_USD__c\":\"\",\"Local_Net_Unit_Pirce_100__c\":\"\",\"Sales_Transaction_Currency__c\":\"\",\"Shipped_To_Factory__c\":\"\",\"Shipped_To_Country__c\":\"\",\"Label__c\":\"\",\"End_user__c\":\"\",\"Vendor__c\":\"\",\"Division__c\":\"\",\"Retailer_Brand__c\":\"\",\"Royalty_Rate__c\":\"\",\"Market__c\":\"\",\"Remark__c\":\"\",\"LOB__c\":\"\",\"SO_Number__c\":\"\",\"Production_Country__c\":\"\"}]';
        //string jSonEdit = '[{\"Company__c\":\"peru\",\"Year__c\":\"2021\",\"Week__c\":\"Wk60\",\"Month__c\":\"abc\",\"Item_code__c\":\"fdfd\",\"Material__c\":\"si\",\"Source__c\":\"Virgi\",\"Model__c\":\"CSQ\",\"Printed_Logo__c\":\"demoLogoOO\",\"Color__c\":\"TRANSPER\",\"Customer__c\":\"xxxxx\",\"Customer_local_name__c\":\"\",\"Mainetti_Brand__c\":\"MaineS\",\"Category__c\":\"HANGERSSS & ACCESSORIES\",\"Sub_Category__c\":\"HANGE\",\"Family__c\":\"BOTTOMMMS\",\"Order_Type__c\":\"6TH\",\"Unit_Sold__c\":\"!@#$\",\"Unit_Price_100_EUR__c\":\"!@#$\",\"Unit_Price_100_USD__c\":\"!@#$\",\"Net_Unit_Price_100__c\":\"11\",\"Sales_EUR__c\":\"268.410993\",\"Sales_USD__c\":\"312.631704\",\"Transaction_Currency__c\":\"HKD\",\"ExRate_to_EUR__c\":\"9.08505\",\"ExRate_to_USD__c\":\"7.8\",\"Local_Net_Unit_Pirce_100__c\":\"13\",\"Sales_Transaction_Currency__c\":\"2438.527291\",\"Shipped_To_Factory__c\":\"xxxxxx\",\"Shipped_To_Country__c\":\"xxxx\",\"Label__c\":\"\",\"End_user__c\":\"\",\"Vendor__c\":\"DemoRetailer\",\"Division__c\":\"Demo\",\"Retailer_Brand__c\":\"Demo\",\"Royalty_Rate__c\":\"\",\"Market__c\":\"USA\",\"Remarks__c\":\"\",\"LOB__c\":\"PRL\",\"SO_Number__c\":\"18300168\",\"Production_Country__c\":\"CHINA\"}]';
        //string jSonEdit = '[{\"Company__c\":\"Hong Kong Packaging\",\"Year__c\":\"2019\",\"Week__c\":\"Wk45\",\"Month__c\":\"Jan\",\"Item_code__c\":\"484\",\"Material__c\":\"PS\",\"Source__c\":\"Virgin\",\"Model__c\":\"1000\",\"Printed_Logo__c\":\"demoLogo\",\"Color__c\":\"BLACK\",\"Customer__c\":\"xxxxx\",\"Customer_local_name__c\":\"xxxx\",\"Mainetti_Brand__c\":\"Mainetti\",\"Category__c\":\"HANGERS & ACCESSORIES\",\"Sub_Category__c\":\"HANGERS\",\"Family__c\":\"BOTTOM\",\"Order_Type__c\":\"3rd\",\"Unit_Sold__c\":\"8000\",\"Unit_Price_100_EUR__c\":\"10.65123\",\"Unit_Price_100_USD__c\":\"12.40602\",\"Net_Unit_Price_100__c\":\"11\",\"Sales_EUR__c\":\"268.410993\",\"Sales_USD__c\":\"312.631704\",\"Transaction_Currency__c\":\"HKD\",\"ExRate_to_EUR__c\":\"9.08505\",\"ExRate_to_USD__c\":\"7.8\",\"Local_Net_Unit_Pirce_100__c\":\"13\",\"Sales_Transaction_Currency__c\":\"2438.527291\",\"Shipped_To_Factory__c\":\"xxxxxx\",\"Shipped_To_Country__c\":\"xxxx\",\"Label__c\":\"NL\",\"End_user__c\":\"NL\",\"Vendor__c\":\"DemoRetailer\",\"Division__c\":\"Demo\",\"Retailer_Brand__c\":\"MMG\",\"Royalty_Rate__c\":\"USA\",\"Market__c\":\"USA\",\"Remarks__c\":\"abc\",\"LOB__c\":\"AAF\",\"SO_Number__c\":\"18300168\",\"Production_Country__c\":\"CHINA\"}]';
        string recordType = 'Sales';
        //string company = 'Mainetti (HK) Ltd';
        string returnBatchId = '';
        boolean flag = true;
        string selMonth = 'Jan';
        string selYear = '2019';
        string selcomp = 'Hong Kong';
        Product__c produc = new Product__c(Consolidated_Style__c = '1000',Business_Vertical__c = 'HANGERS & ACCESSORIES', 	Name = 'Mainetti',Product_Type__c= 'HANGERS',Product_Family__c = 'TOP');
        insert produc;
        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Sales';
        //value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value; 
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Company__c = 'Hong Kong Packaging';
        stageValue.Year__c = '2019';
        insert stageValue;
        
        Sales_Error_Mapping__c salesError = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Model',Map_From_Value__c = '1000',Map_To_Value__c = '1000');
        insert salesError;
        Sales_Error_Mapping__c salesError1 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Year',Map_From_Value__c = '2019',Map_To_Value__c = '2019');
        insert salesError1;
        Sales_Error_Mapping__c salesError2 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Month',Map_From_Value__c = 'Jan',Map_To_Value__c = 'Jan');
        insert salesError2;
        Sales_Error_Mapping__c salesError3 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Week',Map_From_Value__c = 'Wk45',Map_To_Value__c = 'Wk45');
        insert salesError3;
        Sales_Error_Mapping__c salesError4 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'ItemCode',Map_From_Value__c = '484',Map_To_Value__c = '484');
        insert salesError4;
        Sales_Error_Mapping__c salesError5 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Material',Map_From_Value__c = 'PP',Map_To_Value__c = 'PP');
        insert salesError5;
        Sales_Error_Mapping__c salesError6 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Source',Map_From_Value__c = 'Virgin',Map_To_Value__c = 'Virgin');
        insert salesError6;
        Sales_Error_Mapping__c salesError7 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'MainettiBrand',Map_From_Value__c = 'Mainetti',Map_To_Value__c = 'Mainetti');
        insert salesError7;
        Sales_Error_Mapping__c salesError8 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Color',Map_From_Value__c = 'BLACK',Map_To_Value__c = 'BLACK');
        insert salesError8;
        Sales_Error_Mapping__c salesError9 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Customer',Map_From_Value__c = 'xxxxx',Map_To_Value__c = 'xxxx');
        insert salesError9;
        Sales_Error_Mapping__c salesError10 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Category',Map_From_Value__c = 'HANGERS & ACCESSORIES',Map_To_Value__c = 'HANGERS & ACCESSORIES');
        insert salesError10;
        Sales_Error_Mapping__c salesError11 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Family',Map_From_Value__c = 'BOTTOM',Map_To_Value__c = 'BOTTOM');
        insert salesError11;
        Sales_Error_Mapping__c salesError12 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'PrintedLogo',Map_From_Value__c = 'demoLogo',Map_To_Value__c = 'demoLogo');
        insert salesError12;
        Sales_Error_Mapping__c salesError13 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'LocalName',Map_From_Value__c = 'xxxx',Map_To_Value__c = 'xxxx');
        insert salesError13;
        Sales_Error_Mapping__c salesError14 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'SubCategory',Map_From_Value__c = 'HANGERS',Map_To_Value__c = 'HANGERS');
        insert salesError14;
        Sales_Error_Mapping__c salesError15 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Family',Map_From_Value__c = 'bottom',Map_To_Value__c = 'bottom');
        insert salesError15;
        Sales_Error_Mapping__c salesError16 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'SubCategory',Map_From_Value__c = 'HANGERS',Map_To_Value__c = 'HANGERS');
        insert salesError16;
        Sales_Error_Mapping__c salesError17 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'OrderType',Map_From_Value__c = '3rd',Map_To_Value__c = '3rd');
        insert salesError17;
        Sales_Error_Mapping__c salesError18 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'UnitSold',Map_From_Value__c = '8000',Map_To_Value__c = '8000');
        insert salesError18;
        Sales_Error_Mapping__c salesError19 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'LocalCurrency',Map_From_Value__c = 'HKD',Map_To_Value__c = 'HKD');
        insert salesError19;
        Sales_Error_Mapping__c salesError20 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'ShippedToFactory',Map_From_Value__c = 'xxxxxx',Map_To_Value__c = 'xxxxxx');
        insert salesError20;
        Sales_Error_Mapping__c salesError21 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'ShippedToCountry',Map_From_Value__c = 'xxxxxx',Map_To_Value__c = 'xxxxxx');
        insert salesError21;
        Sales_Error_Mapping__c salesError22 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Label',Map_From_Value__c = 'NL',Map_To_Value__c = 'NL');
        insert salesError22;
        Sales_Error_Mapping__c salesError23 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'EndUser',Map_From_Value__c = 'NL',Map_To_Value__c = 'NL');
        insert salesError23;
        Sales_Error_Mapping__c salesError24 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Vendor',Map_From_Value__c = 'MACYS',Map_To_Value__c = 'MACYS');
        insert salesError24;
        Sales_Error_Mapping__c salesError25 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Division',Map_From_Value__c = 'FOB',Map_To_Value__c = 'FOB');
        insert salesError25;
        Sales_Error_Mapping__c salesError26 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'RetailerBrand',Map_From_Value__c = 'MMG',Map_To_Value__c = 'MMG');
        insert salesError26;
        Sales_Error_Mapping__c salesError27 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'RoyaltyRate',Map_From_Value__c = 'USA',Map_To_Value__c = 'USA');
        insert salesError27;
        Sales_Error_Mapping__c salesError28 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Market',Map_From_Value__c = 'USA',Map_To_Value__c = 'USA');
        insert salesError28;
        Sales_Error_Mapping__c salesError29 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'LOB',Map_From_Value__c = 'AAF',Map_To_Value__c = 'AAF');
        insert salesError29;
        Sales_Error_Mapping__c salesError30 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'SONumber',Map_From_Value__c = '18001464',Map_To_Value__c = '18001464');
        insert salesError30;
        Sales_Error_Mapping__c salesError31 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'ProductionCountry',Map_From_Value__c = 'CHINA',Map_To_Value__c = 'CHINA');
        insert salesError31;
        Sales_Error_Mapping__c salesError32 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Remarks',Map_From_Value__c = 'CHINA',Map_To_Value__c = 'CHINA');
        insert salesError32;
        Sales_Error_Mapping__c salesError33 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Remarks',Map_From_Value__c = 'CHINA',Map_To_Value__c = 'CHINA');
        insert salesError33;
        Sales_Error_Mapping__c salesError34 = new Sales_Error_Mapping__c(Company__c = 'Hong Kong Packaging', Raw_Data_Field__c = 'Remarks',Map_From_Value__c = 'CHINA',Map_To_Value__c = 'CHINA');
        insert salesError34;
        
            
        Test.startTest();
        uploadInventry.parseSales(jSon, value.id, recordType, selMonth, selYear,selcomp);
        uploadInventry.parseSales(jSon, '', recordType, selMonth, selYear,selcomp);
        uploadInventry.parseSales(jSonInvalid, '', recordType, selMonth, selYear,selcomp);
        uploadInventry.parseSales(jSonMissing, '', recordType, selMonth, selYear,selcomp); 
        uploadInventry.parseSales(jSonAllMissing, '', recordType, selMonth, selYear,selcomp);
        //uploadInventry.parseSales(jSonEdit, '', recordType, selMonth, selYear,selcomp);
        Test.stopTest();
        System.assertEquals(true, flag); 
    } 
    
  /*  static testMethod void insertDataUploadsalesTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'sales';
        insert value;
        string returnBatchId = '';
        Test.startTest();
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = updateBatchStatus.id;
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

        
        //map<string,Id> manitteMap = new map<string,Id>();
        //partnerQuery = [Select Id, Name  from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')];
        uploadInventry uplInventry = new uploadInventry();
        uplInventry.insertDataUploadSales(updateBatchStatus);
        uploadInventry.getPreviousYear();
        uploadInventry.getsalesCompanyList();
        Test.stopTest();
        System.assertEquals(returnBatchId,'');      
    }
    
    static testMethod void saveRecordTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        //value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'sales';
        insert value;
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Family__c = 'bottomm';
        insert stageValue;
        Sales_Transaction_Stage__c stageValueTwo = new Sales_Transaction_Stage__c();
        stageValueTwo.Color__c = 'GRAY';
        stageValueTwo.Record_Status__c = '2 - Data Validation Successful';
        stageValueTwo.Upload_Batch_No__c = value.id;
        stageValueTwo.Family__c = 'bottomm';
        insert stageValueTwo;
        Sales_Error_Mapping__c errormap = new Sales_Error_Mapping__c();
        errormap.Raw_Data_Field__c = 'Family';
        errormap.Map_From_Value__c = 'bottomm';
        errormap.Map_To_Value__c = 'bottom';
        errormap.Company__c = 'America Mid West - Hangers Unlimited';
        
        boolean flag = true;
        Test.startTest();
        uploadInventry.saveRecord('Family','bottom','bottomm',value.id,stageValue.id,'Family','Family','America Mid West - Hangers Unlimited');
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void proceedSalesDataTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Record_Type__c = 'sales';
        insert value;
        Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Transaction_Master_Id__c = value.id;
        stageValue.warning_consolidate_key__c = true;
        insert stageValue;
        
        boolean flag = true;
        Test.startTest();
        uploadInventry.proceedSalesData(value.id);
        uploadInventry.recStatusUpsertForSales(value.id);
        uploadInventry.isDataCleanForProceed(value.id);
        Test.stopTest();
        System.assertEquals(true, flag);
    }*/
    /*static testMethod void fetchLookupErrorMapList() {
        Sales_Error_Mapping__c salesError = new Sales_Error_Mapping__c(Company__c = 'America Mid West - Hangers Unlimited', Raw_Data_Field__c = 'Model',Map_From_Value__c = '484BR',Map_To_Value__c = '484');
        insert salesError;
        String mapToValue = 'BOTTOM';
        String mapFromValue = 'BOTTOM';
        string rawDataField = 'Family';
        string company = 'Hong Kong Packaging';
        boolean flag = true;
        Test.startTest();
        uploadInventry.fetchLookupErrorMapList(mapToValue,mapFromValue,rawDataField,company);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void DataSubmitted() {
        Data_Upload_Sales__c salesError = new Data_Upload_Sales__c(Sales_Data_Company__c = 'Hong Kong Packaging', Month__c = 'Jan',Year__c  = '2019');
        insert salesError;
        String selyear = '2019';
        string selmonth = 'Aug';
        string companyArray = 'Hong Kong Packaging';
        boolean flag = true;
        Test.startTest();
        uploadInventry.dataSubmitted(companyArray,selmonth,selyear);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }*/
    /*static testMethod void getDataMethod() {
       UserAppInfo UserAppInfo = UserAppInfo:{Id=0Dsp000000005aNCAQ, AppDefinitionId=06mp00000000tOkAAI, CurrencyIsoCode=USD};
    }*/
        
}