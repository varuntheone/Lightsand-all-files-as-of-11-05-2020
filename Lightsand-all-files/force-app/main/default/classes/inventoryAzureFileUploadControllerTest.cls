@IsTest(SeeAllData = true)
public class inventoryAzureFileUploadControllerTest {
    @IsTest(SeeAllData=true) 
    public static void initilizeRecords() {
        Inventory_Transaction_Master__c invTransMast  = new Inventory_Transaction_Master__c();
        insert invTransMast;
        ApexPages.StandardController sc = new ApexPages.StandardController(invTransMast);
        inventoryAzureFileUploadController inv = new inventoryAzureFileUploadController(sc);
        inventoryAzureFileUploadController.azureWrapper aw = inventoryAzureFileUploadController.storageDetails();
        
       /* Inventory_Transaction_Master__c invTransMast = new Inventory_Transaction_Master__c();
        invTransMast.id = 'a1Np000000Ih19kEAB';
        insert invTransMast;
        ApexPages.StandardController sc = new ApexPages.StandardController(invTransMast);
        inventoryAzureFileUploadController inv = new inventoryAzureFileUploadController(sc); */
        
        
        /*Test.startTest();          
        PageReference pageRef = new ApexPages.StandardController(invTransMast).view();
        Test.setCurrentPage(pageRef);          
        
        ApexPages.currentPage().getParameters().put('blobetag',String.valueOf(invTransMast.Id));
        
        String currentRecordId = String.valueOf(ApexPages.currentPage().getParameters().get('blobetag'));
        invTransMast = [select Id  from Inventory_Transaction_Master__c where  Id =:parent.Id ];
        ApexPages.StandardController stdController =   new ApexPages.StandardController(invTransMast);      
        inventoryAzureFileUploadController designController = new inventoryAzureFileUploadController(stdController);   
        Test.stopTest();   */     
    }
    
    @IsTest(SeeAllData=true)
    public static void initilizeCsvRecords() {
      
        
        /*ContentVersion conVers = new ContentVersion(); 
        conVers.Title = 'Sample';
        insert conVers;*/
               
        string csv = '[{"Retailer_Code__c": "GU","Mainetti_Company__c": "Mainetti (HK) Ltd","Inventory_Model__c": "TNGU139","Warehouse__c": "LongHua Factory","Color__c": "GRAY","Sizer_Print__c": "","Local_System_SKU__c": "157946","Source__c": "Virgin","Stock_In_Date__c": "23-May-19","Stock_In_Qty__c": "200",}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        ContentVersion invenotryFile = new ContentVersion();
            invenotryFile.ContentLocation = 'S';
            invenotryFile.VersionData = Blob.valueOf(csv);
            invenotryFile.Title = 'Inventory Data File Uplaod';
            invenotryFile.PathOnClient = fileName;            
            insert invenotryFile;
        ContentVersion inventoryVerContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :invenotryFile.Id];            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=value.id;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=inventoryVerContent.ContentDocumentId;            
            insert contentlink;
        inventoryAzureFileUploadController.csvWrapper csvFile = inventoryAzureFileUploadController.getCsvFileContent(value.id);
    }
    
    @IsTest(seeAllData=true)
    static void getDeleteCSVFileTest() {
        string csv = '[{"Retailer_Code__c": "GU","Mainetti_Company__c": "Mainetti (HK) Ltd","Inventory_Model__c": "TNGU139","Warehouse__c": "LongHua Factory","Color__c": "GRAY","Sizer_Print__c": "","Local_System_SKU__c": "157946","Source__c": "Virgin","Stock_In_Date__c": "23-May-19","Stock_In_Qty__c": "200",}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        ContentVersion invenotryFile = new ContentVersion();
            invenotryFile.ContentLocation = 'S';
            invenotryFile.VersionData = Blob.valueOf(csv);
            invenotryFile.Title = 'Inventory Data File Uplaod';
            invenotryFile.PathOnClient = fileName;            
            insert invenotryFile;
        ContentVersion inventoryVerContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :invenotryFile.Id];            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=value.id;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=inventoryVerContent.ContentDocumentId;            
            insert contentlink;

        boolean flag = true;
        Test.startTest();
        inventoryAzureFileUploadController.getCsvFileContent(value.id);
        inventoryAzureFileUploadController.deleteCSVFile(value.id);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    @IsTest(seeAllData=true)
    static void transferTransctionDataToDataUploadMasterTest() {
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
        
        Inventory_Transaction_Master__c valueSales = new Inventory_Transaction_Master__c(); 
        valueSales.Record_Type__c = 'Sales';
        insert valueSales;
        Sales_Transaction_Stage__c stageValueSales = new Sales_Transaction_Stage__c();
        stageValueSales.Color__c = 'GRAY';
        stageValueSales.Record_Status__c = '2 - Data Validation Successful';
        stageValueSales.Upload_Batch_No__c = valueSales.id;
        stageValueSales.Transaction_Master_Id__c = valueSales.id;
        stageValueSales.Company__c = 'Hong Kong Packaging';
        stageValueSales.Year__c = '2019';
        stageValueSales.Unit_Sold__c = '234';
        stageValueSales.Unit_Price_100_EUR__c = '24';
        stageValueSales.Unit_Price_100_USD__c = '25';
        stageValueSales.Sales_EUR__c = '10';
        stageValueSales.Sales_USD__c = '20';
        stageValueSales.Unit_Sold__c = '234';
        stageValueSales.ExRate_to_EUR__c = '234';
        stageValueSales.ExRate_to_USD__c = '234';
        stageValueSales.Local_Net_Unit_Pirce_100__c = '234';
        stageValueSales.Sales_Transaction_Currency__c = '234';
        stageValueSales.Gross_Sales_USD__c = '12.2';
        stageValueSales.Freight_Charge_USD__c = '2.2';
        insert stageValueSales;
        
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
        //uploadInventry uplInventry = new uploadInventry();
        //uplInventry.insertDataUploadTransaction(updateBatchStatus);
        boolean transferStatus = inventoryAzureFileUploadController.transferTransctionDataToDataUploadMaster(value.id);
        boolean transferStatussales = inventoryAzureFileUploadController.transferTransctionDataToDataUploadMaster(valueSales.id);
        Test.stopTest();
        System.assert(transferStatus,true);
        System.assert(transferStatussales,true);
    }
    @IsTest(seeAllData=true)
    static void getUploadDetailsTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        insert value;
        Inventory_Transaction_Stage__c stageValue = new Inventory_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Sizer_Print__c = 'XS';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Stock_In_Date__c = '23-May-19';
        stageValue.Stock_In_Qty__c = '200';
        insert stageValue;
        Data_Upload_Transaction__c transactionValue = new Data_Upload_Transaction__c();
        transactionValue.Stock_In_Qty__c = 200;
        transactionValue.Upload_Batch_No__c = value.Id;
        insert transactionValue;
        
        Inventory_Transaction_Master__c valueSales = new Inventory_Transaction_Master__c(); 
        valueSales.Record_Type__c = 'Sales';
        insert valueSales;
        Sales_Transaction_Stage__c stageValueSales = new Sales_Transaction_Stage__c();
        stageValueSales.Color__c = 'GRAY';
        stageValueSales.Record_Status__c = '2 - Data Validation Successful';
        stageValueSales.Upload_Batch_No__c = valueSales.id;
        stageValueSales.Transaction_Master_Id__c = valueSales.id;
        stageValueSales.Company__c = 'Hong Kong Packaging';
        stageValueSales.Year__c = '2019';
        stageValueSales.Unit_Sold__c = '234';
        stageValueSales.Unit_Price_100_EUR__c = '24';
        stageValueSales.Unit_Price_100_USD__c = '25';
        stageValueSales.Sales_EUR__c = '10';
        stageValueSales.Sales_USD__c = '20';
        stageValueSales.Unit_Sold__c = '234';
        stageValueSales.ExRate_to_EUR__c = '234';
        stageValueSales.ExRate_to_USD__c = '234';
        stageValueSales.Local_Net_Unit_Pirce_100__c = '234';
        stageValueSales.Sales_Transaction_Currency__c = '234';
        insert stageValueSales;
        
        boolean flag = true;
        Test.startTest();
        inventoryAzureFileUploadController.getUploadDetails(value.Id);
        inventoryAzureFileUploadController.getUploadDetails(valueSales.Id);
        Test.stopTest();
        System.assertEquals(true, flag); 
    }
}